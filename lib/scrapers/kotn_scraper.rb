# frozen_string_literal: true

STDOUT.sync = true

require 'json'
require 'uri'
require 'playwright'

# Kotn Playwright Scraper
# Scraper for kotn.com - Egyptian cotton sustainable fashion brand (Shopify store)
#
# Step 1: Scrapes collection pages to get product URLs
# Step 2: Visits each product page to get accurate price, color, material, and image
#
# Kotn specializes in: T-shirts, Denim, Outerwear, Knitwear, Home goods
#
# Requirements:
#   gem install playwright-ruby-client
#   npx playwright install chromium
#
# Usage:
#   ruby lib/scrapers/kotn_scraper.rb [query] [limit] [--visible] [--no-save]
#   ruby lib/scrapers/kotn_scraper.rb t-shirt 10 --visible
#   ruby lib/scrapers/kotn_scraper.rb denim 10 --visible
#   ruby lib/scrapers/kotn_scraper.rb jacket 10 --visible
#
module KotnPlaywrightScraper
  BASE_URL = "https://kotn.com"

  PAGE_LOAD_DELAY = 2.0
  BETWEEN_PRODUCTS_DELAY = 1.5

  # Collection URLs mapping (verified Jan 2026)
  COLLECTION_URLS = {
    't-shirt' => '/collections/mens-tshirts',
    't-shirts' => '/collections/mens-tshirts',
    'tee' => '/collections/mens-tshirts',
    'tops' => '/collections/mens-tops',
    'pants' => '/collections/mens-bottoms',
    'bottoms' => '/collections/mens-bottoms',
    'trousers' => '/collections/mens-bottoms',
    'jacket' => '/collections/mens-outerwear',
    'jackets' => '/collections/mens-outerwear',
    'outerwear' => '/collections/mens-outerwear',
    'hoodie' => '/collections/mens-outerwear',
    'lounge' => '/collections/mens-lounge',
    'womens-tshirts' => '/collections/womens-tshirts',
    'womens-tops' => '/collections/womens-tops',
    'womens' => '/collections/womens',
    'mens' => '/collections/mens',
    'all' => '/collections/mens'
  }.freeze

  # Clothing type inference map
  CLOTHING_TYPE_INFERENCE = {
    /jacket|coat|parka|blazer|overshirt/i => "Jacket",
    /sweater|cardigan|pullover|knit/i => "Sweater",
    /hoodie|sweatshirt/i => "Hoodie",
    /t-shirt|tee|tank/i => "T-Shirt",
    /shirt|oxford|button/i => "Shirt",
    /jeans|denim|jean/i => "Jeans",
    /pants|trousers|chino|sweatpant/i => "Pants",
    /shorts/i => "Shorts",
    /dress/i => "Dress"
  }.freeze

  class Error < StandardError; end

  class Scraper
    BRAND_NAME = "Kotn"

    def initialize(headless: true)
      @headless = headless
      @browser = nil
      @page = nil
    end

    def search(query, limit: 10)
      puts "=" * 60
      puts "Kotn Playwright Scraper"
      puts "=" * 60
      puts "\nQuery: '#{query}' | Limit: #{limit}"
      puts "Mode: #{@headless ? 'Headless' : 'Visible browser'}"
      puts "-" * 60

      products = []

      Playwright.create(playwright_cli_executable_path: 'npx playwright') do |playwright|
        @browser = playwright.chromium.launch(
          headless: @headless,
          args: ['--disable-blink-features=AutomationControlled', '--no-sandbox']
        )

        context = @browser.new_context(
          viewport: { width: 1280, height: 800 },
          userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36',
          locale: 'en-US'
        )
        @page = context.new_page

        begin
          puts "\n[STEP 1] Scraping collection page..."
          product_urls = scrape_collection_page(query, limit + 5)
          puts "Found #{product_urls.size} products"

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

    def scrape_collection_page(query, limit)
      collection_path = COLLECTION_URLS[query.downcase] || "/collections/all"
      url = "#{BASE_URL}#{collection_path}"

      puts "Using collection page: #{url}"
      @page.goto(url, waitUntil: 'domcontentloaded', timeout: 60000)
      sleep(PAGE_LOAD_DELAY + 2)

      puts "Current URL: #{@page.url}"
      puts "Page title: #{@page.title}"

      # Dismiss any popups
      3.times { @page.keyboard.press('Escape') rescue nil; sleep(0.3) }

      # Wait for products
      begin
        @page.wait_for_selector('a[href*="/products/"]', timeout: 15000)
      rescue StandardError
        puts "Warning: No product links found after waiting"
      end

      # Scroll to load more products
      4.times do
        @page.keyboard.press('End')
        sleep(1.5)
      end

      # Extract product links
      products = @page.evaluate(<<~JS)
        () => {
          const products = [];
          const seen = new Set();

          document.querySelectorAll('a[href*="/products/"]').forEach(link => {
            const href = link.getAttribute('href');
            if (!href || seen.has(href)) return;

            // Skip non-product links
            if (href.includes('gift-card') || href.includes('shipping')) return;

            const urlPath = href.split('?')[0];
            if (seen.has(urlPath)) return;
            seen.add(urlPath);
            seen.add(href);

            // Get product name
            let name = '';
            const parent = link.closest('div[class*="product"]') || link.closest('li') || link.parentElement?.parentElement;
            if (parent) {
              const heading = parent.querySelector('h2, h3, [class*="title"], [class*="name"]');
              if (heading) name = heading.textContent.trim();
            }
            if (!name) name = link.textContent.trim();
            if (!name || name.length < 3) return;

            // Get price
            let price = '';
            if (parent) {
              const priceText = parent.innerText;
              const priceMatch = priceText.match(/\\$([\\d.]+)/);
              if (priceMatch) price = priceMatch[1];
            }

            // Get image
            let image = '';
            const img = link.querySelector('img') || parent?.querySelector('img');
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

      # Dismiss popups
      2.times { @page.keyboard.press('Escape') rescue nil; sleep(0.3) }

      @page.evaluate(<<~JS)
        () => {
          const name = document.querySelector('h1')?.textContent?.trim() || '';

          // Get price
          let price = 0;
          const priceMatch = document.body.innerText.match(/\\$([\\d.]+)\\s*(?:USD|CAD)?/);
          if (priceMatch) price = parseFloat(priceMatch[1]);

          // Get color - Kotn often has color in the variant selector or URL
          let color = 'Unknown';
          const colorEl = document.querySelector('[class*="color"] [class*="selected"], [data-selected-color]');
          if (colorEl) {
            color = colorEl.textContent?.trim() || colorEl.getAttribute('data-selected-color') || 'Unknown';
          }
          // Try URL parameter
          if (color === 'Unknown') {
            const urlParams = new URLSearchParams(window.location.search);
            const variantColor = urlParams.get('Color') || urlParams.get('color');
            if (variantColor) color = variantColor;
          }
          // Try extracting from visible text
          if (color === 'Unknown') {
            const colorPatterns = ['White', 'Black', 'Navy', 'Grey', 'Charcoal', 'Natural', 'Cream', 'Indigo', 'Blue', 'Green', 'Brown', 'Tan', 'Olive'];
            for (const c of colorPatterns) {
              if (document.body.innerText.includes('Color: ' + c) || document.body.innerText.includes('Colour: ' + c)) {
                color = c;
                break;
              }
            }
          }

          // Get material - extract just the composition (e.g., "100% cotton")
          let material = '100% Egyptian Cotton';
          const pageText = document.body.innerText;

          // Look for composition patterns like "100% cotton" or "85% cotton, 15% recycled cotton"
          const compositionPatterns = [
            /(\\d+%\\s*(?:organic\\s+)?(?:Egyptian\\s+)?cotton(?:\\s*,?\\s*\\d+%\\s*(?:recycled\\s+)?(?:cotton|elastane|spandex|polyester))*)/i,
            /(\\d+%\\s*(?:wool|linen|tencel|lyocell|viscose)(?:\\s*,?\\s*\\d+%\\s*\\w+)*)/i
          ];

          for (const pattern of compositionPatterns) {
            const match = pageText.match(pattern);
            if (match) {
              // Clean up and capitalize properly
              material = match[1]
                .replace(/\\s+/g, ' ')
                .trim()
                .replace(/cotton/gi, 'Cotton')
                .replace(/egyptian/gi, 'Egyptian')
                .replace(/organic/gi, 'Organic')
                .replace(/recycled/gi, 'Recycled')
                .replace(/wool/gi, 'Wool')
                .replace(/elastane/gi, 'Elastane');
              // Limit length
              if (material.length > 60) material = material.substring(0, 60);
              break;
            }
          }

          // Fallback based on keywords
          if (material === '100% Egyptian Cotton') {
            if (pageText.toLowerCase().includes('organic cotton')) {
              material = '100% Organic Egyptian Cotton';
            } else if (pageText.toLowerCase().includes('recycled cotton')) {
              material = 'Recycled Cotton Blend';
            }
          }

          // Get main product image
          let image = '';
          const mainImg = document.querySelector('img[src*="cdn.shopify.com"][src*="products"]');
          if (mainImg) {
            image = mainImg.src;
          }
          if (!image) {
            const imgs = document.querySelectorAll('img[src*="cdn.shopify.com"]');
            for (const img of imgs) {
              if (img.src && !img.src.includes('icon') && !img.src.includes('logo') && img.width > 200) {
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
      { 'name' => '', 'price' => 0, 'color' => 'Unknown', 'material' => 'Egyptian Cotton', 'image' => '' }
    end

    def build_product(search_info, page_details)
      name = page_details['name'].to_s.empty? ? search_info[:name] : page_details['name']
      color = page_details['color'].to_s == 'Unknown' ? extract_color(name) : page_details['color']
      image = page_details['image'].to_s.empty? ? search_info[:image] : page_details['image']

      price = page_details['price'].to_f
      price = search_info[:price].to_f if price.zero? && search_info[:price]

      {
        product_description: name,
        clothing_item: infer_clothing_type(name),
        clothing_material: page_details['material'] || 'Egyptian Cotton',
        clothing_colour: color,
        clothing_brand: BRAND_NAME,
        clothing_price: price,
        item_image: ensure_absolute_url(image),
        external_link: ensure_absolute_url(search_info[:url])
      }
    end

    def extract_color(name)
      colors = {
        /white/i => 'White', /black/i => 'Black', /navy/i => 'Navy',
        /grey|gray/i => 'Grey', /charcoal/i => 'Charcoal', /natural/i => 'Natural',
        /cream/i => 'Cream', /indigo/i => 'Indigo', /blue/i => 'Blue',
        /green|olive/i => 'Green', /brown|tan/i => 'Brown'
      }
      colors.each { |pattern, color| return color if name.match?(pattern) }
      'Unknown'
    end

    def infer_clothing_type(name)
      return "Apparel" if name.nil? || name.empty?
      CLOTHING_TYPE_INFERENCE.each { |pattern, type| return type if name.match?(pattern) }
      "Apparel"
    end

    def ensure_absolute_url(url)
      return '' if url.nil? || url.empty?
      return url if url.start_with?('http')
      "#{BASE_URL}#{url.start_with?('/') ? '' : '/'}#{url}"
    end
  end

  def self.scrape(query, limit: 10, headless: true)
    Scraper.new(headless: headless).search(query, limit: limit)
  end
end

# Standalone execution
if __FILE__ == $0
  query = ARGV[0] || "t-shirt"
  limit = (ARGV[1] || 10).to_i
  headless = !ARGV.include?('--visible')
  save_to_db = !ARGV.include?('--no-save')

  products = KotnPlaywrightScraper.scrape(query, limit: limit, headless: headless)

  if products.empty?
    puts "\nNo products found."
    exit 0
  end

  puts "\n" + "=" * 60
  puts "RESULTS: #{products.size} products"
  puts "=" * 60

  products.each_with_index do |p, i|
    puts "\n#{i + 1}. #{p[:product_description]}"
    puts "   Type: #{p[:clothing_item]} | Material: #{p[:clothing_material]}"
    puts "   Color: #{p[:clothing_colour]} | Price: $#{p[:clothing_price]}"
    puts "   Image: #{p[:item_image]&.slice(0, 50)}..."
  end

  if save_to_db
    puts "\n" + "=" * 60
    puts "Saving to database..."
    puts "=" * 60

    require_relative '../../config/environment'

    brand = Brand.find_by(name: 'Kotn')
    unless brand
      puts "Creating Kotn brand with Good On You ratings..."
      brand = Brand.create!(
        name: 'Kotn',
        description: "Certified B Corp (95.5 score) making essentials from Egyptian cotton. Direct trade with farmers in the Nile Delta, funding 15+ schools in rural Egypt. Transparent supply chain with SA 8000 and OEKO-TEX certified facilities.",
        planet_rating: 3.0,   # "It's a Start" on Good On You
        people_rating: 4.5,   # "Great" on Good On You
        animals_rating: 4.0,  # No animal products used
        overall_rating: 4.0   # "Great" overall on Good On You
      )
      puts "Created brand: #{brand.name}"
    end

    created = 0
    skipped = 0

    products.each do |p|
      if ComparisonProduct.exists?(external_link: p[:external_link])
        puts "SKIP: #{p[:product_description]} (exists)"
        skipped += 1
      else
        ComparisonProduct.create!(p.merge(brand: brand))
        puts "CREATED: #{p[:product_description]}"
        created += 1
      end
    end

    puts "\n" + "=" * 60
    puts "Database: #{created} created, #{skipped} skipped"
    puts "Total Kotn products: #{ComparisonProduct.where(clothing_brand: 'Kotn').count}"
    puts "=" * 60
  end
end
