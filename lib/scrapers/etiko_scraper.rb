# frozen_string_literal: true

# Ensure output is flushed immediately
STDOUT.sync = true

require 'json'
require 'uri'
require 'playwright'

# Etiko Playwright Scraper
# Scraper for etiko.com.au - Australian ethical fashion brand (Shopify store)
#
# Step 1: Scrapes collection pages to get product URLs
# Step 2: Visits each product page to get accurate price, color, material, and image
#
# Note: Etiko specializes in t-shirts, hoodies, underwear, and footwear.
#       They don't have traditional jackets or shorts.
#
# Requirements:
#   gem install playwright-ruby-client
#   npx playwright install chromium
#
# Usage:
#   ruby lib/scrapers/etiko_scraper.rb [query] [limit] [--visible] [--no-save]
#   ruby lib/scrapers/etiko_scraper.rb t-shirt 15 --visible
#   ruby lib/scrapers/etiko_scraper.rb hoodie 10 --visible --no-save
#
# By default, saves scraped products to the database. Use --no-save to skip.
#
module EtikoPlaywrightScraper
  BASE_URL = "https://etiko.com.au"

  # Delays to avoid detection
  PAGE_LOAD_DELAY = 1.0
  BETWEEN_PRODUCTS_DELAY = 0.75

  # Collection URLs mapping
  COLLECTION_URLS = {
    't-shirt' => '/collections/t-shirts-mens',
    't-shirts' => '/collections/t-shirts-mens',
    'tee' => '/collections/t-shirts-mens',
    'mens-t-shirt' => '/collections/t-shirts-mens',
    'womens-t-shirt' => '/collections/t-shirts-womens',
    'hoodie' => '/collections/crew-neck-and-hoodies',
    'hoodies' => '/collections/crew-neck-and-hoodies',
    'jacket' => '/collections/crew-neck-and-hoodies', # Etiko hoodies are closest to jackets
    'jackets' => '/collections/crew-neck-and-hoodies',
    'sweater' => '/collections/crew-neck-and-hoodies',
    'clothing' => '/collections/clothing',
    'all' => '/collections/clothing'
  }.freeze

  # Clothing type inference map
  CLOTHING_TYPE_INFERENCE = {
    /hoodie|hooded/i => "Hoodie",
    /crew neck|crewneck|pullover/i => "Sweater",
    /t-shirt|tee|round neck|v-neck/i => "T-Shirt",
    /singlet|tank/i => "Tank Top",
    /polo/i => "Polo",
    /long sleeve/i => "Long Sleeve Shirt",
    /underwear|boxer|brief|boyleg/i => "Underwear",
    /sock/i => "Socks"
  }.freeze

  class Error < StandardError; end

  class Scraper
    BRAND_NAME = "Etiko"

    def initialize(headless: true)
      @headless = headless
      @browser = nil
      @page = nil
    end

    # Main entry point - search and scrape products
    def search(query, limit: 10)
      puts "=" * 60
      puts "Etiko Playwright Scraper"
      puts "=" * 60
      puts "\nQuery: '#{query}' | Limit: #{limit}"
      puts "Mode: #{@headless ? 'Headless' : 'Visible browser'}"
      puts "-" * 60

      products = []

      Playwright.create(playwright_cli_executable_path: find_playwright_cli) do |playwright|
        # Launch Chromium
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
          locale: 'en-AU'
        )
        @page = context.new_page

        begin
          # Step 1: Get product URLs from collection
          puts "\n[STEP 1] Scraping collection page..."
          product_urls = scrape_collection_page(query, limit + 5)
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

    def scrape_collection_page(query, limit)
      # Use collection URL if available
      collection_path = COLLECTION_URLS[query.downcase] || "/collections/clothing"
      url = "#{BASE_URL}#{collection_path}"

      puts "Using collection page: #{url}"
      @page.goto(url, waitUntil: 'domcontentloaded', timeout: 60000)
      sleep(PAGE_LOAD_DELAY + 1)

      # Handle cookie consent
      dismiss_cookie_banner

      # Debug: show current URL and title
      puts "Current URL: #{@page.url}"
      puts "Page title: #{@page.title}"

      # Wait for product grid to appear
      begin
        @page.wait_for_selector('a[href*="/products/"]', timeout: 15000)
      rescue StandardError
        puts "Warning: No product links found after waiting"
      end

      # Scroll down to load more products
      3.times do
        @page.keyboard.press('End')
        sleep(1)
      end

      # Extract product links from collection
      products = @page.evaluate(<<~JS)
        () => {
          const products = [];
          const seen = new Set();

          // Find all product links in the collection grid
          const links = document.querySelectorAll('a[href*="/products/"]');

          links.forEach(link => {
            const href = link.getAttribute('href');
            if (!href || seen.has(href)) return;

            // Skip non-product links
            if (href.includes('gift-card') || href.includes('shipping-protection') || href.includes('clearance-items')) return;

            // Get product URL path for deduplication
            const urlPath = href.split('?')[0];
            if (seen.has(urlPath)) return;
            seen.add(urlPath);
            seen.add(href);

            // Get product name from h3 heading or link text
            let name = '';
            const h3 = link.querySelector('h3');
            if (h3) {
              name = h3.textContent.trim();
            } else {
              // Try parent container
              const parent = link.closest('li') || link.closest('div');
              if (parent) {
                const heading = parent.querySelector('h3');
                if (heading) name = heading.textContent.trim();
              }
            }

            // Skip if no name found
            if (!name || name.length < 3) return;

            // Get price
            let price = '';
            const parent = link.closest('li') || link.closest('div');
            if (parent) {
              const priceText = parent.innerText;
              // Match EUR price format like "€6,95 EUR"
              const priceMatch = priceText.match(/€([\\d,]+)/);
              if (priceMatch) {
                price = priceMatch[1].replace(',', '.');
              }
            }

            // Get image
            let image = '';
            const img = link.querySelector('img');
            if (img) {
              image = img.getAttribute('src') || img.getAttribute('data-src') || '';
            }

            products.push({ name, url: href, price, image });
          });

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

      # Dismiss cookie banner if present
      dismiss_cookie_banner

      # Extract product details
      @page.evaluate(<<~JS)
        () => {
          // Get product name from h1
          const name = document.querySelector('h1')?.textContent?.trim() || '';

          // Get price - format: "€6,95 EUR" or "A$12.95"
          let price = 0;
          const priceEl = document.querySelector('[class*="price"]');
          if (priceEl) {
            const priceText = priceEl.textContent;
            // Handle EUR format
            const eurMatch = priceText.match(/€([\\d,]+)/);
            if (eurMatch) {
              price = parseFloat(eurMatch[1].replace(',', '.'));
            }
            // Handle AUD format
            const audMatch = priceText.match(/A?\\$([\\d.]+)/);
            if (audMatch) {
              price = parseFloat(audMatch[1]);
            }
          }

          // Extract color from product name
          let color = 'Unknown';
          const colorPatterns = ['White', 'Black', 'Navy', 'Grey', 'Charcoal', 'Green', 'Blue', 'Red', 'Pink', 'Marle', 'Natural'];
          for (const c of colorPatterns) {
            if (name.toLowerCase().includes(c.toLowerCase())) {
              color = c;
              // Handle "Grey Marle" or "Blue Marle"
              if (name.toLowerCase().includes('marle')) {
                const marleMatch = name.match(/(\\w+)\\s+Marle/i);
                if (marleMatch) {
                  color = marleMatch[1] + ' Marle';
                }
              }
              break;
            }
          }

          // Get material from product description
          let material = 'Organic Cotton';
          const pageText = document.body.innerText;

          // Look for "WHAT'S IN YOUR" section
          const whatsInMatch = pageText.match(/WHAT'S IN YOUR[^:]*:([^•]*(?:•[^•]*)*?)(?:Made in|$)/is);
          if (whatsInMatch) {
            // Extract the material info
            const materialInfo = whatsInMatch[1].trim();
            if (materialInfo.includes('organic cotton')) {
              material = 'Fairtrade Organic Cotton';
            }
          }

          // Look for specific material mentions
          if (pageText.includes('100% organic cotton')) {
            material = '100% Organic Cotton';
          } else if (pageText.includes('95% organic cotton')) {
            material = '95% Organic Cotton';
          } else if (pageText.includes('Fairtrade') && pageText.includes('organic cotton')) {
            material = 'Fairtrade Organic Cotton';
          }

          // Get main product image
          let image = '';

          // Look for product gallery images (Shopify product media)
          const gallerySelectors = [
            '.product__media img',
            '.product-gallery img',
            '[data-product-media-type="image"] img',
            '.product-single__media img',
            '.product__main-photos img',
            'img[src*="/products/"]'
          ];

          for (const selector of gallerySelectors) {
            const img = document.querySelector(selector);
            if (img) {
              const src = img.src || img.getAttribute('data-src') || '';
              // Skip brand logos and badges
              if (src && !src.includes('Digital_Tag') && !src.includes('Media_Kit') && !src.includes('logo')) {
                image = src;
                break;
              }
            }
          }

          // Fallback: look for any product image on Shopify CDN
          if (!image) {
            const imgs = document.querySelectorAll('img[src*="cdn.shopify.com"]');
            for (const img of imgs) {
              const src = img.src || '';
              // Skip icons, logos, badges, and brand tags
              if (src && !src.includes('icon') && !src.includes('logo') && !src.includes('Digital_Tag') && !src.includes('Media_Kit')) {
                image = src;
                break;
              }
            }
          }

          return { name, price, color, material, image };
        }
      JS
    rescue StandardError => e
      puts "    Error scraping product page: #{e.message}"
      { 'name' => '', 'price' => 0, 'color' => 'Unknown', 'material' => 'Organic Cotton', 'image' => '' }
    end

    def dismiss_cookie_banner
      begin
        # Look for "Allow All" or "Accept" button
        accept_btn = @page.query_selector('a:has-text("Allow All")')
        if accept_btn
          accept_btn.click
          sleep(0.5)
        end
      rescue StandardError
        # Banner not present
      end

      begin
        # Also try "Decline All" to dismiss
        decline_btn = @page.query_selector('a:has-text("Decline All")')
        if decline_btn
          decline_btn.click
          sleep(0.5)
        end
      rescue StandardError
        # Banner not present
      end
    end

    def build_product(search_info, page_details)
      name = page_details['name'].to_s.empty? ? search_info[:name] : page_details['name']

      # Use color from page details if available
      color = page_details['color'].to_s == 'Unknown' ? extract_color_from_name(name) : page_details['color']

      # Use image from search if page didn't have one
      image = page_details['image'].to_s.empty? ? search_info[:image] : page_details['image']

      # Convert price to float (prices are in EUR on the site, convert to AUD approximately)
      price = page_details['price'].to_f
      price = search_info[:price].to_f if price.zero? && search_info[:price]

      {
        product_description: name,
        clothing_item: infer_clothing_type(name),
        clothing_material: page_details['material'] || 'Organic Cotton',
        clothing_colour: color,
        clothing_brand: BRAND_NAME,
        clothing_price: price,
        item_image: ensure_absolute_url(image),
        external_link: ensure_absolute_url(search_info[:url])
      }
    end

    def extract_color_from_name(name)
      color_patterns = {
        /white/i => 'White',
        /black/i => 'Black',
        /navy/i => 'Navy',
        /grey marle/i => 'Grey Marle',
        /blue marle/i => 'Blue Marle',
        /grey/i => 'Grey',
        /charcoal/i => 'Charcoal',
        /green/i => 'Green',
        /blue/i => 'Blue',
        /red/i => 'Red',
        /pink/i => 'Pink',
        /natural/i => 'Natural'
      }

      color_patterns.each do |pattern, color|
        return color if name.match?(pattern)
      end

      'Unknown'
    end

    def infer_clothing_type(product_name)
      return "Apparel" if product_name.nil? || product_name.empty?

      CLOTHING_TYPE_INFERENCE.each do |pattern, clothing_type|
        return clothing_type if product_name.match?(pattern)
      end

      "T-Shirt" # Default for Etiko
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
    products = EtikoPlaywrightScraper.scrape(query, limit: limit, headless: headless)

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

        brand = Brand.find_by(name: 'Etiko')
        unless brand
          puts "Etiko brand not found. Creating it..."
          brand = Brand.create!(
            name: 'Etiko',
            description: "Australia's most ethical clothing brand. Fairtrade certified, 100% organic cotton, vegan-friendly. Committed to paying living wages and environmentally sustainable practices.",
            planet_rating: 5.0,
            people_rating: 5.0,
            animals_rating: 5.0,
            overall_rating: 5.0
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
        puts "Total Etiko products: #{ComparisonProduct.where(clothing_brand: EtikoPlaywrightScraper::Scraper::BRAND_NAME).count}"
        puts "=" * 60
      else
        puts "\n" + "=" * 60
        puts "JSON Output:"
        puts "=" * 60
        puts JSON.pretty_generate(products)
      end
    end
  rescue EtikoPlaywrightScraper::Error => e
    puts "\nError: #{e.message}"
    exit 1
  rescue StandardError => e
    puts "\nUnexpected error: #{e.message}"
    puts e.backtrace.first(5).join("\n")
    exit 1
  end
end
