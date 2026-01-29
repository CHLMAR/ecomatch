# frozen_string_literal: true

# Ensure output is flushed immediately
STDOUT.sync = true

require 'json'
require 'uri'
require 'playwright'

# Lululemon Playwright Scraper
# Simple two-step scraper using browser automation
#
# Step 1: Scrapes search results to get product URLs
# Step 2: Visits each product page to get accurate price, color, material, and image
#
# Note: Lululemon doesn't sell traditional jeans - use 'pants' or 'joggers' instead
#
# Requirements:
#   gem install playwright-ruby-client
#   npx playwright install chromium
#
# Usage:
#   ruby lib/scrapers/lululemon_scraper.rb [query] [limit] [--visible] [--no-save]
#   ruby lib/scrapers/lululemon_scraper.rb t-shirt 20 --visible
#   ruby lib/scrapers/lululemon_scraper.rb pants 20 --visible
#   ruby lib/scrapers/lululemon_scraper.rb jacket 10 --visible
#
# By default, saves scraped products to the database. Use --no-save to skip.
#
module LululemonPlaywrightScraper
  BASE_URL = "https://shop.lululemon.com"

  # Delays to avoid detection
  PAGE_LOAD_DELAY = 3.0
  BETWEEN_PRODUCTS_DELAY = 2.0

  # Clothing type inference map
  CLOTHING_TYPE_INFERENCE = {
    /jacket|coat|parka|windbreaker|bomber|define|down for it/i => "Jacket",
    /sweater|sweatshirt|hoodie|pullover|scuba/i => "Sweater",
    /t-shirt|tee|tank|crop|vitasea/i => "T-Shirt",
    /shirt|button|polo/i => "Shirt",
    /jogger|pant|trouser|commission|abc/i => "Pants",
    /shorts|short/i => "Shorts",
    /legging|tight|align|wunder/i => "Leggings",
    /bra|sports bra/i => "Sports Bra",
    /dress|skirt/i => "Dress"
  }.freeze

  class Error < StandardError; end

  class Scraper
    BRAND_NAME = "Lululemon"

    def initialize(headless: true)
      @headless = headless
      @browser = nil
      @page = nil
    end

    # Main entry point - search and scrape products
    def search(query, limit: 10)
      puts "=" * 60
      puts "Lululemon Playwright Scraper"
      puts "=" * 60
      puts "\nQuery: '#{query}' | Limit: #{limit}"
      puts "Mode: #{@headless ? 'Headless' : 'Visible browser'}"
      puts "-" * 60

      products = []

      Playwright.create(playwright_cli_executable_path: find_playwright_cli) do |playwright|
        # Launch Chromium - visible mode recommended for Lululemon
        @browser = playwright.chromium.launch(
          headless: @headless,
          args: [
            '--disable-blink-features=AutomationControlled',
            '--no-sandbox',
            '--disable-dev-shm-usage'
          ]
        )

        # Create context with realistic settings
        context = @browser.new_context(
          viewport: { width: 1440, height: 900 },
          userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36',
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

    # Category URL mapping for more reliable scraping (updated Jan 2026)
    CATEGORY_URLS = {
      'pants' => '/c/women-pants/n1qd1q',
      'joggers' => '/c/women-pants/n1qd1q',
      't-shirt' => '/c/women-shirts/n1atfg',
      't-shirts' => '/c/women-shirts/n1atfg',
      'shirts' => '/c/women-shirts/n1atfg',
      'tee' => '/c/women-shirts/n1atfg',
      'jacket' => '/c/women-coats-and-jackets/n1p54j',
      'jackets' => '/c/women-coats-and-jackets/n1p54j',
      'leggings' => '/c/women-leggings/n1udsq'
    }.freeze

    def scrape_search_page(query, limit)
      # Use category URL if available (more reliable), otherwise search
      category_path = CATEGORY_URLS[query.downcase]
      if category_path
        url = "#{BASE_URL}#{category_path}"
        puts "Using category page: #{url}"
      else
        encoded_query = URI.encode_www_form_component(query)
        url = "#{BASE_URL}/search?Ntt=#{encoded_query}"
        puts "Using search page: #{url}"
      end

      puts "Navigating to: #{url}"
      @page.goto(url, waitUntil: 'domcontentloaded', timeout: 60000)
      sleep(PAGE_LOAD_DELAY + 5)  # Extra time for JS rendering

      # Dismiss any dialogs
      dismiss_dialogs

      # Debug: show current URL and title
      puts "Current URL: #{@page.url}"
      puts "Page title: #{@page.title}"

      # Wait for product grid to appear - Lululemon loads products via JS
      puts "  Waiting for products to load..."
      begin
        @page.wait_for_selector('a[href*="/p/"]', timeout: 20000)
        sleep(3)  # Additional wait for all products to render
      rescue StandardError
        puts "Warning: No product links found after waiting"
      end

      # Dismiss search suggestions dropdown
      @page.keyboard.press('Escape')
      sleep(1)

      # Scroll to load more products
      4.times do |i|
        @page.keyboard.press('End')
        sleep(2)
        puts "  Scrolled #{i + 1}/4 times..."
      end
      @page.keyboard.press('Home')
      sleep(1.5)

      # Extract product links - use a more robust approach
      products = @page.evaluate(<<~JS)
        () => {
          const products = [];
          const seenUrls = new Set();

          // Find ALL anchor elements and filter for product links
          const allAnchors = document.querySelectorAll('a');

          for (const link of allAnchors) {
            const href = link.getAttribute('href') || '';

            // Only process product links (must contain /p/ and prod)
            if (!href.includes('/p/') || !href.includes('prod')) continue;

            // Skip if we've seen this product URL (dedupe by base path)
            const baseUrl = href.split('?')[0];
            if (seenUrls.has(baseUrl)) continue;
            seenUrls.add(baseUrl);

            // Extract product name from URL as primary source (most reliable)
            let name = '';
            const urlMatch = href.match(/\\/p\\/[^/]+\\/([^/]+)\\/_/);
            if (urlMatch) {
              // Convert URL slug to readable name: "Dance-Studio-Pant-MR-Reg" -> "Dance Studio Pant Mr Reg"
              name = urlMatch[1]
                .replace(/-/g, ' ')
                .replace(/\\b\\w/g, l => l.toUpperCase())
                .replace(/\\bMr\\b/i, 'Mid-Rise')
                .replace(/\\bHr\\b/i, 'High-Rise')
                .replace(/\\bLr\\b/i, 'Low-Rise')
                .replace(/\\bReg\\b/i, 'Regular');
            }

            if (!name || name.length < 3) continue;

            // Get price from nearby container
            let price = '';
            let container = link.parentElement;
            for (let i = 0; i < 5 && container; i++) {
              const text = container.innerText || '';
              const priceMatch = text.match(/\\$(\\d+)/);
              if (priceMatch) {
                price = priceMatch[1];
                break;
              }
              container = container.parentElement;
            }

            // Get image from link or nearby
            let image = '';
            const img = link.querySelector('img');
            if (img) {
              const src = img.getAttribute('src') || '';
              if (src && !src.startsWith('data:')) {
                image = src;
              }
            }

            products.push({ name, url: href, price, image });
          }

          return products;
        }
      JS

      puts "  Raw products found: #{products.size}"
      products.first(limit).map { |p| { name: p['name'], url: p['url'], price: p['price'], image: p['image'] } }
    end

    def scrape_product_page(product_url)
      full_url = product_url.start_with?('http') ? product_url : "#{BASE_URL}#{product_url}"

      @page.goto(full_url, waitUntil: 'domcontentloaded', timeout: 60000)
      sleep(PAGE_LOAD_DELAY)

      # Dismiss any dialogs
      dismiss_dialogs

      # Try to expand Material and care accordion
      begin
        @page.keyboard.press('Escape')
        sleep(0.3)
        material_button = @page.query_selector('button[data-lulu-track="pdp-accordion-material-and-care"]')
        if material_button
          material_button.scroll_into_view_if_needed
          sleep(0.3)
          material_button.click
          sleep(0.8)
        end
      rescue StandardError
        # Accordion might not exist
      end

      # Extract product details
      @page.evaluate(<<~JS)
        () => {
          // Get product name from h1
          const name = document.querySelector('h1')?.textContent?.trim() || '';

          // Get price
          let price = 0;
          const pageText = document.body.innerText;
          const priceMatch = pageText.match(/\\$(\\d+)\\s*(?:USD|CAD)?/);
          if (priceMatch) price = parseFloat(priceMatch[1]);

          // Get color
          let color = 'Unknown';
          const colorMatch = pageText.match(/Colour\\s*([A-Za-z\\s]+?)(?:\\n|Select|Size|\\$|\\d)/i);
          if (colorMatch) color = colorMatch[1].trim();

          // Get material from expanded Material and care section
          let material = 'Unknown';
          const bodyMatch = pageText.match(/Body[:\\s]+([\\d%A-Za-z,\\s]+?)(?:Care|Machine|Do Not|Lining)/i);
          if (bodyMatch) {
            material = bodyMatch[1].trim().replace(/[,\\s]+$/, '');
          }
          // Fallback: look for percentage patterns
          if (material === 'Unknown' || material.length < 5) {
            const patterns = pageText.match(/(\\d+%\\s*(?:Nylon|Polyester|Elastane|Lycra|Spandex|Cotton)[\\w\\s,%-]*)/gi);
            if (patterns && patterns.length > 0) {
              material = patterns.reduce((a, b) => a.length > b.length ? a : b).trim();
            }
          }
          if (material.length > 80) material = material.substring(0, 80);

          // Get main product image
          let image = '';
          const slideImg = document.querySelector('img[alt*="Slide 1"]');
          if (slideImg && slideImg.src && !slideImg.src.startsWith('data:')) {
            image = slideImg.src;
          }
          if (!image) {
            const imgs = document.querySelectorAll('img[src*="lululemon"]');
            for (const img of imgs) {
              if (img.src && !img.src.startsWith('data:') && !img.src.includes('icon') && !img.src.includes('logo')) {
                image = img.src;
                break;
              }
            }
          }

          return { name, price, color, material, image };
        }
      JS
    rescue StandardError => e
      puts "    Error scraping product page: #{e.message}"
      { 'name' => '', 'price' => 0, 'color' => 'Unknown', 'material' => 'Unknown', 'image' => '' }
    end

    def dismiss_dialogs
      # Press Escape to close any modals
      3.times do
        begin
          @page.keyboard.press('Escape')
          sleep(0.2)
        rescue StandardError
          # Ignore
        end
      end

      # Try to close promotional banners
      begin
        close_btn = @page.query_selector('button[data-testid="close-button"]')
        close_btn&.click
        sleep(0.2)
      rescue StandardError
        # Banner not present
      end
    end

    def build_product(search_info, page_details)
      name = page_details['name'].to_s.empty? ? search_info[:name] : page_details['name']
      color = page_details['color'].to_s == 'Unknown' ? 'Unknown' : page_details['color']
      image = page_details['image'].to_s.empty? ? search_info[:image] : page_details['image']

      price = page_details['price'].to_f
      price = search_info[:price].to_f if price.zero? && search_info[:price]

      {
        product_description: name,
        clothing_item: infer_clothing_type(name),
        clothing_material: page_details['material'] || 'Unknown',
        clothing_colour: color,
        clothing_brand: BRAND_NAME,
        clothing_price: price,
        item_image: ensure_absolute_url(image),
        external_link: ensure_absolute_url(search_info[:url])
      }
    end

    def infer_clothing_type(product_name)
      return "Apparel" if product_name.nil? || product_name.empty?

      CLOTHING_TYPE_INFERENCE.each do |pattern, clothing_type|
        return clothing_type if product_name.match?(pattern)
      end

      "Apparel"
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
  query = ARGV[0] || "t-shirt"
  limit = (ARGV[1] || 10).to_i
  headless = !ARGV.include?('--visible')
  save_to_db = !ARGV.include?('--no-save')

  begin
    products = LululemonPlaywrightScraper.scrape(query, limit: limit, headless: headless)

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

        brand = Brand.find_by(name: 'Lululemon')
        unless brand
          puts "Lululemon brand not found. Creating it..."
          brand = Brand.create!(
            name: 'Lululemon',
            description: 'Athletic apparel company known for yoga wear and technical athletic clothing. Committed to sustainable practices including recycled materials and responsible manufacturing.',
            planet_rating: 3.5,
            people_rating: 3.0,
            animals_rating: 3.5,
            overall_rating: 3.3
          )
          puts "Created brand: #{brand.name}"
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
        puts "Total Lululemon products: #{ComparisonProduct.where(clothing_brand: LululemonPlaywrightScraper::Scraper::BRAND_NAME).count}"
        puts "=" * 60
      else
        puts "\n" + "=" * 60
        puts "JSON Output:"
        puts "=" * 60
        puts JSON.pretty_generate(products)
      end
    end
  rescue LululemonPlaywrightScraper::Error => e
    puts "\nError: #{e.message}"
    exit 1
  rescue StandardError => e
    puts "\nUnexpected error: #{e.message}"
    puts e.backtrace.first(5).join("\n")
    exit 1
  end
end
