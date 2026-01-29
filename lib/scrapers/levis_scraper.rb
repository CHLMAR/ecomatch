# frozen_string_literal: true

require 'json'
require 'uri'
require 'playwright'

# Levi's Playwright Scraper
# Two-step scraper using browser automation to bypass anti-bot protection
#
# Step 1: Scrapes search results to get product URLs
# Step 2: Visits each product page to get accurate price, color, material, and image
#
# Requirements:
#   gem install playwright-ruby-client
#   npx playwright install chromium
#
# Usage:
#   ruby lib/scrapers/levis_scraper.rb [query] [limit] [--visible] [--no-save]
#   ruby lib/scrapers/levis_scraper.rb jeans 15 --visible
#   ruby lib/scrapers/levis_scraper.rb jacket 10 --visible --no-save
#
# By default, saves scraped products to the database. Use --no-save to skip.
#
module LevisPlaywrightScraper
  BASE_URL = "https://www.levi.com"

  # Delays to avoid detection - Levi's has aggressive anti-bot
  PAGE_LOAD_DELAY = 4.0
  BETWEEN_PRODUCTS_DELAY = 2.0

  # Clothing type inference map
  CLOTHING_TYPE_INFERENCE = {
    /jacket|trucker|sherpa|denim jacket/i => "Jacket",
    /sweater|hoodie|pullover|sweatshirt/i => "Sweater",
    /t-shirt|tee|tank/i => "T-Shirt",
    /shirt|button|western/i => "Shirt",
    /jeans|501|505|511|512|514|517|550|559|541|565|568|578/i => "Jeans",
    /pants|trousers|chino/i => "Pants",
    /shorts/i => "Shorts",
    /dress|skirt/i => "Dress",
    /overalls/i => "Overalls"
  }.freeze

  class Error < StandardError; end

  class Scraper
    BRAND_NAME = "Levi's"

    def initialize(headless: true)
      @headless = headless
      @browser = nil
      @page = nil
    end

    # Main entry point - search and scrape products
    def search(query, limit: 10)
      puts "=" * 60
      puts "Levi's Playwright Scraper"
      puts "=" * 60
      puts "\nQuery: '#{query}' | Limit: #{limit}"
      puts "Mode: #{@headless ? 'Headless' : 'Visible browser'}"
      puts "-" * 60

      products = []

      Playwright.create(playwright_cli_executable_path: find_playwright_cli) do |playwright|
        # Launch Chromium with minimal settings - sometimes less detection is better
        @browser = playwright.chromium.launch(
          headless: @headless,
          slowMo: 100  # Slow down operations to appear more human
        )

        # Create context with realistic viewport
        context = @browser.new_context(
          viewport: { width: 1920, height: 1080 },
          locale: 'en-US'
        )
        @page = context.new_page

        begin
          # Step 1: Get product URLs from search
          puts "\n[STEP 1] Scraping search results..."
          product_urls = scrape_search_page(query, limit + 5)
          puts "Found #{product_urls.size} products"

          # Step 2: Visit each product page
          puts "\n[STEP 2] Fetching product details..."
          product_urls.first(limit).each_with_index do |product_info, index|
            break if products.size >= limit

            puts "\n[#{index + 1}/#{limit}] #{product_info[:name]}"

            details = scrape_product_page(product_info[:url])

            products << build_product(product_info, details)

            sleep(BETWEEN_PRODUCTS_DELAY) if index < limit - 1
          end
        ensure
          @browser&.close
        end
      end

      puts "\n" + "=" * 60
      puts "Completed: #{products.size} products scraped"
      puts "=" * 60

      products
    end

    private

    def find_playwright_cli
      # Try common locations for playwright CLI
      paths = [
        'npx playwright',
        './node_modules/.bin/playwright',
        `which playwright`.strip
      ]

      paths.each do |path|
        return path unless path.empty?
      end

      'npx playwright'
    end

    # Map queries to category URLs - search pages are often blocked
    CATEGORY_URLS = {
      'jeans' => '/US/en_US/clothing/men/jeans/c/levi_clothing_men_jeans',
      'mens-jeans' => '/US/en_US/clothing/men/jeans/c/levi_clothing_men_jeans',
      'womens-jeans' => '/US/en_US/clothing/women/jeans/c/levi_clothing_women_jeans',
      'jacket' => '/US/en_US/clothing/men/outerwear/c/levi_clothing_men_outerwear',
      'jackets' => '/US/en_US/clothing/men/outerwear/c/levi_clothing_men_outerwear',
      't-shirt' => '/US/en_US/clothing/men/shirts/c/levi_clothing_men_shirts',
      't-shirts' => '/US/en_US/clothing/men/shirts/c/levi_clothing_men_shirts',
      'shirt' => '/US/en_US/clothing/men/shirts/c/levi_clothing_men_shirts',
      'shirts' => '/US/en_US/clothing/men/shirts/c/levi_clothing_men_shirts',
      'shorts' => '/US/en_US/clothing/men/shorts/c/levi_clothing_men_shorts',
      'pants' => '/US/en_US/clothing/men/pants/c/levi_clothing_men_trousers_pants'
    }.freeze

    def scrape_search_page(query, limit)
      # First visit homepage to establish cookies and pass bot detection
      puts "Warming up session with homepage visit..."
      @page.goto("#{BASE_URL}/US/en_US/", waitUntil: 'domcontentloaded', timeout: 60000)
      sleep(PAGE_LOAD_DELAY)

      # Handle any cookie consent dialogs
      dismiss_cookie_dialog

      # Use category URL if available (more reliable), otherwise search
      category_path = CATEGORY_URLS[query.downcase]
      if category_path
        url = "#{BASE_URL}#{category_path}"
        puts "Using category page: #{url}"
      else
        encoded_query = URI.encode_www_form_component(query)
        url = "#{BASE_URL}/US/en_US/search/#{encoded_query}"
        puts "Using search page: #{url}"
      end

      puts "Navigating to: #{url}"
      @page.goto(url, waitUntil: 'domcontentloaded', timeout: 60000)
      sleep(PAGE_LOAD_DELAY + 3)  # Extra time for JS to render products

      # Debug: show current URL and title
      puts "Current URL: #{@page.url}"
      puts "Page title: #{@page.title}"

      # Wait for product elements to appear
      begin
        @page.wait_for_selector('a[href*="/p/"]', timeout: 15000)
      rescue StandardError
        puts "Warning: No product links found after waiting"
      end

      # Extract product links with /p/ pattern
      products = @page.evaluate(<<~JS)
        () => {
          const products = [];
          const seen = new Set();
          const links = document.querySelectorAll('a[href*="/p/"]');

          links.forEach(link => {
            const href = link.getAttribute('href');
            if (!href || seen.has(href)) return;
            seen.add(href);

            // Get product name from URL path or link text
            let name = link.textContent?.trim() || '';
            if (!name || name.length < 3) {
              // Extract name from URL path
              const pathMatch = href.match(/\\/([a-z0-9-]+)\\/p\\//i);
              if (pathMatch) {
                name = pathMatch[1].replace(/-/g, ' ').replace(/\\b\\w/g, l => l.toUpperCase());
              }
            }

            // Get image if available
            const img = link.querySelector('img');
            const imgSrc = img ? (img.getAttribute('src') || img.getAttribute('data-src')) : null;

            if (name) {
              products.push({ name, url: href, image: imgSrc });
            }
          });

          return products;
        }
      JS

      products.first(limit).map { |p| { name: p['name'], url: p['url'], image: p['image'] } }
    end

    def scrape_product_page(product_url)
      full_url = product_url.start_with?('http') ? product_url : "#{BASE_URL}#{product_url}"

      @page.goto(full_url, waitUntil: 'domcontentloaded')
      sleep(PAGE_LOAD_DELAY)

      # Extract product details
      @page.evaluate(<<~JS)
        () => {
          // Get product name from h1
          const name = document.querySelector('h1')?.textContent?.trim() || '';

          // Get price - look for the main price display (not promotional text)
          let price = 0;
          // Look for price elements with $ symbol
          const priceElements = document.querySelectorAll('[class*="price"], [class*="Price"]');
          for (const el of priceElements) {
            const text = el.textContent;
            const match = text.match(/\\$(\\d+\\.?\\d*)/);
            if (match) {
              price = parseFloat(match[1]);
              break;
            }
          }
          // Fallback: search in specific areas
          if (price === 0) {
            const bodyText = document.body.innerText;
            // Look for price after "Sale price is" or standalone price
            const saleMatch = bodyText.match(/Sale price is\\s*\\$(\\d+\\.?\\d*)/);
            if (saleMatch) {
              price = parseFloat(saleMatch[1]);
            } else {
              // Look for the product price pattern
              const priceMatch = bodyText.match(/\\$(\\d{2,3}\\.\\d{2})/);
              if (priceMatch) {
                price = parseFloat(priceMatch[1]);
              }
            }
          }

          // Get selected color from "Color:" text
          let color = 'Unknown';
          const colorMatch = document.body.innerText.match(/Color:\\s*([^\\n]+)/);
          if (colorMatch) {
            color = colorMatch[1].trim().split(' - ')[0].trim();
          }

          // Get material from Composition & Care section
          let material = 'Denim';
          const listItems = document.querySelectorAll('li');
          for (const li of listItems) {
            const text = li.textContent?.trim();
            if (text && text.match(/\\d+%\\s*(Cotton|Polyester|Elastane|Spandex|Lyocell|Viscose)/i)) {
              material = text;
              break;
            }
          }

          // Get main product image - prefer hi-res from scene7
          let image = '';

          // Look for scene7 images and get hi-res version
          const scene7Imgs = document.querySelectorAll('img[src*="scene7"]');
          for (const img of scene7Imgs) {
            const src = img.src || '';
            if (src.includes('scene7') && !src.includes('swatch')) {
              // Modify URL to request larger image (800x1066 for product images)
              image = src.replace(/wid=\\d+/, 'wid=800').replace(/hei=\\d+/, 'hei=1066');
              break;
            }
          }

          // Fallback: look for any product image
          if (!image) {
            const mainImg = document.querySelector('img[alt*="Image of"]');
            if (mainImg) {
              let src = mainImg.src || mainImg.getAttribute('data-src') || '';
              // Ensure hi-res dimensions
              if (src.includes('scene7')) {
                src = src.replace(/wid=\\d+/, 'wid=800').replace(/hei=\\d+/, 'hei=1066');
              }
              image = src;
            }
          }

          return { name, price, color, material, image };
        }
      JS
    rescue StandardError => e
      puts "    Error scraping product page: #{e.message}"
      { 'name' => '', 'price' => 0, 'color' => 'Unknown', 'material' => 'Denim', 'image' => '' }
    end

    def dismiss_cookie_dialog
      begin
        # Levi's cookie consent button
        accept_btn = @page.get_by_role('button', name: /accept|agree|ok|continue/i)
        if accept_btn.visible?(timeout: 2000)
          accept_btn.click
          sleep(0.5)
        end
      rescue StandardError
        # Dialog not present or already dismissed
      end
    end

    def build_product(search_info, page_details)
      name = page_details['name'].to_s.empty? ? search_info[:name] : page_details['name']

      # Use image from search results if product page didn't have one
      image = page_details['image'].to_s.empty? ? search_info[:image] : page_details['image']

      # Upgrade image to hi-res if it's a scene7 URL
      image = upgrade_to_hires_image(image)

      {
        product_description: name,
        clothing_item: infer_clothing_type(name),
        clothing_material: page_details['material'] || 'Denim',
        clothing_colour: page_details['color'] || 'Unknown',
        clothing_brand: BRAND_NAME,
        clothing_price: page_details['price'].to_f,
        item_image: ensure_absolute_url(image),
        external_link: ensure_absolute_url(search_info[:url])
      }
    end

    def upgrade_to_hires_image(url)
      return '' if url.nil? || url.empty?
      return url unless url.include?('scene7')

      # Replace small dimensions with larger ones for hi-res images
      url.gsub(/wid=\d+/, 'wid=800').gsub(/hei=\d+/, 'hei=1066')
    end

    def infer_clothing_type(product_name)
      return "Jeans" if product_name.nil? || product_name.empty?

      CLOTHING_TYPE_INFERENCE.each do |pattern, clothing_type|
        return clothing_type if product_name.match?(pattern)
      end

      "Jeans" # Default for Levi's
    end

    def ensure_absolute_url(url)
      return '' if url.nil? || url.empty?
      return url if url.start_with?('http')
      "#{BASE_URL}#{url.start_with?('/') ? '' : '/'}#{url}"
    end
  end

  # Convenience method for Rails integration
  def self.scrape(query, limit: 10, headless: true)
    scraper = Scraper.new(headless: headless)
    scraper.search(query, limit: limit)
  end
end

# Standalone execution
if __FILE__ == $0
  query = ARGV[0] || "jeans"
  limit = (ARGV[1] || 10).to_i
  headless = !ARGV.include?('--visible')
  save_to_db = !ARGV.include?('--no-save')

  begin
    products = LevisPlaywrightScraper.scrape(query, limit: limit, headless: headless)

    if products.empty?
      puts "\nNo products found."
    else
      puts "\n" + "=" * 60
      puts "RESULTS: #{products.size} products"
      puts "=" * 60

      products.each_with_index do |product, index|
        puts "\n#{index + 1}. #{product[:product_description]}"
        puts "   Type: #{product[:clothing_item]}"
        puts "   Material: #{product[:clothing_material]}"
        puts "   Color: #{product[:clothing_colour]}"
        puts "   Price: $#{product[:clothing_price]}"
        puts "   Image: #{product[:item_image]&.slice(0, 50)}..."
        puts "   Link: #{product[:external_link]}"
      end

      # Save to database by default
      if save_to_db
        puts "\n" + "=" * 60
        puts "Saving to database..."
        puts "=" * 60

        # Load Rails environment
        require_relative '../../config/environment'

        brand = Brand.find_by(name: "Levi's")
        unless brand
          puts "ERROR: Levi's brand not found in database. Run rails db:seed first."
          exit 1
        end

        created = 0
        skipped = 0

        products.each do |p|
          existing = ComparisonProduct.find_by(external_link: p[:external_link])
          if existing
            puts "SKIP: #{p[:product_description]} (already exists)"
            skipped += 1
          else
            ComparisonProduct.create!(
              brand: brand,
              product_description: p[:product_description],
              clothing_item: p[:clothing_item],
              clothing_material: p[:clothing_material],
              clothing_colour: p[:clothing_colour],
              clothing_brand: p[:clothing_brand],
              clothing_price: p[:clothing_price],
              item_image: p[:item_image],
              external_link: p[:external_link]
            )
            puts "CREATED: #{p[:product_description]}"
            created += 1
          end
        end

        puts "\n" + "=" * 60
        puts "Database: #{created} created, #{skipped} skipped"
        puts "Total Levi's products: #{ComparisonProduct.where(clothing_brand: LevisPlaywrightScraper::Scraper::BRAND_NAME).count}"
        puts "=" * 60
      else
        puts "\n" + "=" * 60
        puts "JSON Output:"
        puts "=" * 60
        puts JSON.pretty_generate(products)
      end
    end
  rescue LevisPlaywrightScraper::Error => e
    puts "\nError: #{e.message}"
    exit 1
  rescue StandardError => e
    puts "\nUnexpected error: #{e.message}"
    puts e.backtrace.first(5).join("\n")
    exit 1
  end
end
