# frozen_string_literal: true

require 'json'
require 'uri'
require 'playwright'

# MUD Jeans Playwright Scraper
# Two-step scraper using browser automation to bypass anti-bot protection
#
# Step 1: Scrapes search/collection results to get product URLs
# Step 2: Visits each product page to get accurate price, color, material, and image
#
# Requirements:
#   gem install playwright-ruby-client
#   npx playwright install chromium
#
# Usage:
#   ruby lib/scrapers/mudjeans_scraper.rb [query] [limit] [--visible] [--no-save]
#   ruby lib/scrapers/mudjeans_scraper.rb jeans 15 --visible
#   ruby lib/scrapers/mudjeans_scraper.rb "mens-jeans" 30 --visible
#   ruby lib/scrapers/mudjeans_scraper.rb "womens-jeans" 30 --visible
#   ruby lib/scrapers/mudjeans_scraper.rb t-shirt 10 --visible --no-save
#
# By default, saves scraped products to the database. Use --no-save to skip.
#
module MudJeansPlaywrightScraper
  BASE_URL = "https://mudjeans.com"

  # Delays to avoid detection
  PAGE_LOAD_DELAY = 3.0
  BETWEEN_PRODUCTS_DELAY = 1.5

  # Clothing type inference map
  CLOTHING_TYPE_INFERENCE = {
    /jeans|straight|slim|tapered|flared|loose|baggy|skinny/i => "Jeans",
    /jacket|denim jacket/i => "Jacket",
    /t-shirt|tee/i => "T-Shirt",
    /shirt/i => "Shirt",
    /shorts/i => "Shorts",
    /skirt/i => "Skirt"
  }.freeze

  # Category URL mapping for gender-specific searches
  # Uses search with gender filter or collection pages
  CATEGORY_URLS = {
    'mens-jeans' => '/collections/men',
    'men-jeans' => '/collections/men',
    'womens-jeans' => '/collections/women',
    'women-jeans' => '/collections/women',
    'men' => '/collections/men',
    'women' => '/collections/women',
    't-shirt' => '/search?q=t-shirt',
    't-shirts' => '/search?q=t-shirt'
  }.freeze

  class Error < StandardError; end

  class Scraper
    BRAND_NAME = "MUD Jeans"

    def initialize(headless: true)
      @headless = headless
      @browser = nil
      @page = nil
    end

    # Main entry point - search and scrape products
    def search(query, limit: 10)
      puts "=" * 60
      puts "MUD Jeans Playwright Scraper"
      puts "=" * 60
      puts "\nQuery: '#{query}' | Limit: #{limit}"
      puts "Mode: #{@headless ? 'Headless' : 'Visible browser'}"
      puts "-" * 60

      products = []

      Playwright.create(playwright_cli_executable_path: find_playwright_cli) do |playwright|
        # Launch Chromium with anti-detection settings
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
          viewport: { width: 1280, height: 800 },
          userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36',
          locale: 'en-US'
        )
        @page = context.new_page

        begin
          # Step 1: Get product URLs from search/collection
          puts "\n[STEP 1] Scraping search results..."
          product_urls = scrape_search_page(query, limit + 10)
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

    def scrape_search_page(query, limit)
      # Use category URL if available, otherwise search
      category_path = CATEGORY_URLS[query.downcase]
      if category_path
        url = "#{BASE_URL}#{category_path}"
        puts "Using category page: #{url}"
      else
        encoded_query = URI.encode_www_form_component(query)
        url = "#{BASE_URL}/search?q=#{encoded_query}"
        puts "Using search page: #{url}"
      end

      puts "Navigating to: #{url}"
      @page.goto(url, waitUntil: 'domcontentloaded', timeout: 60000)
      sleep(PAGE_LOAD_DELAY)

      # Handle cookie consent dialog
      dismiss_cookie_dialog

      # Handle location/country dialog
      dismiss_location_dialog

      # Debug: show current URL and title
      puts "Current URL: #{@page.url}"
      puts "Page title: #{@page.title}"

      # Wait for product elements to appear
      begin
        @page.wait_for_selector('a[href*="/products/"]', timeout: 15000)
      rescue StandardError
        puts "Warning: No product links found after waiting"
      end

      # Scroll to load more products if needed
      scroll_for_more_products(limit)

      # Extract product links from search/collection results
      products = @page.evaluate(<<~JS)
        () => {
          const products = [];
          const seen = new Set();

          // Find all product links
          const links = document.querySelectorAll('a[href*="/products/"]');

          links.forEach(link => {
            const href = link.getAttribute('href');
            if (!href || seen.has(href)) return;

            // Skip gift cards and non-product pages
            if (href.includes('gift-card')) return;

            // Get clean URL without query params
            const cleanUrl = href.split('?')[0];
            if (seen.has(cleanUrl)) return;
            seen.add(cleanUrl);

            // Get product name from link text or nested elements
            let name = '';
            const nameEl = link.querySelector('[class*="product-title"], [class*="name"]');
            if (nameEl) {
              name = nameEl.textContent.trim();
            } else {
              // Try to get from the link itself or parent structure
              const textContent = link.textContent.trim();
              // Filter out just prices and empty strings
              if (textContent && !textContent.match(/^€[\\d,]+$/) && textContent.length > 3) {
                name = textContent.split('\\n')[0].trim();
              }
            }

            // Get image if available
            const img = link.querySelector('img');
            const imgSrc = img ? (img.getAttribute('src') || img.getAttribute('data-src')) : '';

            if (name && name.length > 2) {
              products.push({ name, url: cleanUrl, image: imgSrc });
            }
          });

          return products;
        }
      JS

      products.first(limit).map { |p| { name: p['name'], url: p['url'], image: p['image'] } }
    end

    def scroll_for_more_products(target_count)
      # Scroll down multiple times to load more products
      3.times do
        @page.evaluate('window.scrollTo(0, document.body.scrollHeight)')
        sleep(1)
      end
    end

    def scrape_product_page(product_url)
      full_url = product_url.start_with?('http') ? product_url : "#{BASE_URL}#{product_url}"

      @page.goto(full_url, waitUntil: 'domcontentloaded', timeout: 60000)
      sleep(PAGE_LOAD_DELAY)

      # Dismiss dialogs if they reappear
      dismiss_cookie_dialog
      dismiss_location_dialog

      # Try to expand Materials accordion to get full composition
      begin
        materials_btn = @page.locator('[title="Materials"], [data-accordion-toggle*="materials"]').first
        if materials_btn.visible?(timeout: 2000)
          materials_btn.click
          sleep(0.5)
        end
      rescue StandardError
        # Materials section might not exist or already expanded
      end

      # Extract product details
      @page.evaluate(<<~JS)
        () => {
          // Get product name from h1
          const h1 = document.querySelector('h1');
          const fullName = h1 ? h1.textContent.trim() : '';

          // Extract color from product name (format: "Name - Color")
          let name = fullName;
          let color = 'Unknown';
          if (fullName.includes(' - ')) {
            const parts = fullName.split(' - ');
            name = parts[0].trim();
            color = parts.slice(1).join(' - ').trim();
          }

          // Get price - MUD Jeans uses format "€90,97" or "€90,97 €129,95" for sale
          let price = 0;
          const priceText = document.body.innerText;
          // Look for the first price pattern
          const priceMatch = priceText.match(/€([\\d]+)[,.]([\\d]{2})/);
          if (priceMatch) {
            price = parseFloat(priceMatch[1] + '.' + priceMatch[2]);
          }

          // Get material from Materials accordion content
          let material = 'Recycled denim blend';
          const materialsSection = document.querySelector('[title="Materials"]');
          if (materialsSection) {
            const parent = materialsSection.closest('group') || materialsSection.parentElement;
            if (parent) {
              const materialText = parent.innerText;
              // Look for composition details
              const compositionMatch = materialText.match(/([\\d]+%[^.]+(?:[,;][\\d]+%[^.]+)*)/);
              if (compositionMatch) {
                material = compositionMatch[1].trim();
              }
            }
          }

          // Also check for material in expanded content
          const expandedMaterial = document.querySelector('[title="Materials"] + p, [title="Materials"] ~ p');
          if (expandedMaterial) {
            const text = expandedMaterial.innerText;
            if (text.includes('%')) {
              material = text.replace(/\\s+/g, ' ').trim();
            }
          }

          // Fallback: search for material composition anywhere
          if (material === 'Recycled denim blend') {
            const allText = document.body.innerText;
            const compositionPatterns = [
              /Stretch denim:\\s*([^.]+\\d+%[^.]+)/i,
              /(\\d+%\\s*(?:organic|recycled|TENCEL)[^.]+(?:,\\s*\\d+%[^.]+)*)/i
            ];
            for (const pattern of compositionPatterns) {
              const match = allText.match(pattern);
              if (match) {
                material = match[1].trim();
                break;
              }
            }
          }

          // Get main product image
          let image = '';
          const mainImg = document.querySelector('main img[src*="cdn.shopify.com"], main img[src*="mudjeans.com"]');
          if (mainImg) {
            image = mainImg.src;
          }

          // Fallback: look for product images
          if (!image) {
            const productImgs = document.querySelectorAll('img[alt*="Sustainable"], img[alt*="MUD Jeans"]');
            if (productImgs.length > 0) {
              image = productImgs[0].src || '';
            }
          }

          return { name, fullName, price, color, material, image };
        }
      JS
    rescue StandardError => e
      puts "    Error scraping product page: #{e.message}"
      { 'name' => '', 'fullName' => '', 'price' => 0, 'color' => 'Unknown', 'material' => 'Recycled denim blend', 'image' => '' }
    end

    def dismiss_cookie_dialog
      begin
        accept_btn = @page.get_by_role('button', name: /accept/i)
        if accept_btn.visible?(timeout: 2000)
          accept_btn.click
          sleep(0.5)
        end
      rescue StandardError
        # Dialog not present
      end
    end

    def dismiss_location_dialog
      begin
        # MUD Jeans shows "Shop Now" button for location confirmation
        shop_btn = @page.get_by_role('button', name: /shop now/i)
        if shop_btn.visible?(timeout: 2000)
          shop_btn.click
          sleep(0.5)
        end
      rescue StandardError
        # Dialog not present
      end

      begin
        # Also try to close any modal dialogs
        close_btn = @page.get_by_role('button', name: /close/i)
        if close_btn.visible?(timeout: 1000)
          close_btn.click
          sleep(0.3)
        end
      rescue StandardError
        # No close button
      end
    end

    def build_product(search_info, page_details)
      # Use full name from page details if available
      name = page_details['fullName'].to_s.empty? ? search_info[:name] : page_details['fullName']

      # Color from page details
      color = page_details['color'].to_s == 'Unknown' ? extract_color_from_name(search_info[:name]) : page_details['color']

      # Use image from search if page didn't have one
      image = page_details['image'].to_s.empty? ? search_info[:image] : page_details['image']

      {
        product_description: name,
        clothing_item: infer_clothing_type(name),
        clothing_material: page_details['material'] || 'Recycled denim blend',
        clothing_colour: color,
        clothing_brand: BRAND_NAME,
        clothing_price: page_details['price'].to_f,
        item_image: ensure_absolute_url(image),
        external_link: ensure_absolute_url(search_info[:url])
      }
    end

    def extract_color_from_name(name)
      return 'Unknown' if name.nil? || name.empty?

      if name.include?(' - ')
        parts = name.split(' - ')
        return parts.last.strip if parts.length > 1
      end

      'Unknown'
    end

    def infer_clothing_type(product_name)
      return "Jeans" if product_name.nil? || product_name.empty?

      CLOTHING_TYPE_INFERENCE.each do |pattern, clothing_type|
        return clothing_type if product_name.match?(pattern)
      end

      "Jeans" # Default for MUD Jeans
    end

    def ensure_absolute_url(url)
      return '' if url.nil? || url.empty?
      return url if url.start_with?('http')
      return "https:#{url}" if url.start_with?('//')
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
    products = MudJeansPlaywrightScraper.scrape(query, limit: limit, headless: headless)

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
        puts "   Price: €#{product[:clothing_price]}"
        puts "   Image: #{product[:item_image]&.slice(0, 60)}..."
        puts "   Link: #{product[:external_link]}"
      end

      # Save to database by default
      if save_to_db
        puts "\n" + "=" * 60
        puts "Saving to database..."
        puts "=" * 60

        # Load Rails environment
        require_relative '../../config/environment'

        brand = Brand.find_by(name: 'MUD Jeans')
        unless brand
          puts "MUD Jeans brand not found. Creating it..."
          brand = Brand.create!(
            name: 'MUD Jeans',
            description: 'Dutch circular denim brand pioneering lease-a-jeans model. Made from recycled and organic cotton, designed for recyclability.',
            planet_rating: 5.0,
            people_rating: 4.5,
            animals_rating: 4.5,
            overall_rating: 4.5
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
        puts "Total MUD Jeans products: #{ComparisonProduct.where(clothing_brand: MudJeansPlaywrightScraper::Scraper::BRAND_NAME).count}"
        puts "=" * 60
      else
        puts "\n" + "=" * 60
        puts "JSON Output:"
        puts "=" * 60
        puts JSON.pretty_generate(products)
      end
    end
  rescue MudJeansPlaywrightScraper::Error => e
    puts "\nError: #{e.message}"
    exit 1
  rescue StandardError => e
    puts "\nUnexpected error: #{e.message}"
    puts e.backtrace.first(5).join("\n")
    exit 1
  end
end
