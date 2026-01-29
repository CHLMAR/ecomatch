# frozen_string_literal: true

require 'json'
require 'uri'
require 'playwright'

# ASKET Playwright Scraper
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
#   ruby lib/scrapers/asket_scraper.rb [query] [limit] [--visible] [--no-save]
#   ruby lib/scrapers/asket_scraper.rb t-shirt 15 --visible
#   ruby lib/scrapers/asket_scraper.rb jeans 10 --visible --no-save
#
# By default, saves scraped products to the database. Use --no-save to skip.
#
module AsketPlaywrightScraper
  BASE_URL = "https://www.asket.com"
  LOCALE = "en-de"

  # Delays to avoid detection
  PAGE_LOAD_DELAY = 2.0
  BETWEEN_PRODUCTS_DELAY = 1.5

  # Clothing type inference map
  CLOTHING_TYPE_INFERENCE = {
    /jacket|coat|parka|overshirt|blazer/i => "Jacket",
    /sweater|sweatshirt|hoodie|cardigan|knit/i => "Sweater",
    /t-shirt|tee/i => "T-Shirt",
    /shirt|oxford/i => "Shirt",
    /jeans|denim/i => "Jeans",
    /pants|trousers|chino/i => "Pants",
    /shorts/i => "Shorts",
    /polo/i => "Polo",
    /vest/i => "Vest",
    /cap|beanie|hat/i => "Hat",
    /scarf/i => "Scarf",
    /socks/i => "Socks",
    /underwear|boxer/i => "Underwear"
  }.freeze

  class Error < StandardError; end

  class Scraper
    BRAND_NAME = "ASKET"

    def initialize(headless: true)
      @headless = headless
      @browser = nil
      @page = nil
    end

    # Main entry point - search and scrape products
    def search(query, limit: 10)
      puts "=" * 60
      puts "ASKET Playwright Scraper"
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

    def scrape_search_page(query, limit)
      encoded_query = URI.encode_www_form_component(query)
      url = "#{BASE_URL}/#{LOCALE}/search?s=#{encoded_query}"

      puts "Navigating to: #{url}"
      @page.goto(url, waitUntil: 'domcontentloaded', timeout: 60000)
      sleep(PAGE_LOAD_DELAY + 2)

      # Handle cookie consent dialog
      dismiss_cookie_dialog

      # Handle location confirmation dialog
      dismiss_location_dialog

      # Debug: show current URL and title
      puts "Current URL: #{@page.url}"
      puts "Page title: #{@page.title}"

      # Wait for product grid to appear
      begin
        @page.wait_for_selector('article', timeout: 15000)
      rescue StandardError
        puts "Warning: No product articles found after waiting"
      end

      # Extract product links from search results
      products = @page.evaluate(<<~JS)
        () => {
          const products = [];
          const seen = new Set();

          // Find all product articles in the grid
          const articles = document.querySelectorAll('article');

          articles.forEach(article => {
            const link = article.closest('a') || article.querySelector('a');
            if (!link) return;

            const href = link.getAttribute('href');
            if (!href || seen.has(href)) return;
            if (!href.includes('/mens-') && !href.includes('/womens-')) return;
            seen.add(href);

            // Get product name from paragraph or link text
            const nameEl = article.querySelector('p');
            let name = nameEl ? nameEl.textContent.trim() : '';

            // Get price
            let price = '';
            const priceMatch = article.innerText.match(/(\\d+)\\s*EUR/);
            if (priceMatch) {
              price = priceMatch[1];
            }

            // Get color from the article
            const colorParagraphs = article.querySelectorAll('p');
            let color = '';
            colorParagraphs.forEach(p => {
              const text = p.textContent.trim();
              // Colors often come after the price, look for color-like text
              if (text && !text.includes('EUR') && text !== name && text.length > 2 && text.length < 30) {
                // Likely a color
                if (!text.includes('+') && !text.match(/^\\d/)) {
                  color = text;
                }
              }
            });

            // Get image
            const img = article.querySelector('img');
            const imgSrc = img ? (img.getAttribute('src') || img.getAttribute('data-src')) : '';

            if (name) {
              products.push({ name, url: href, price, color, image: imgSrc });
            }
          });

          return products;
        }
      JS

      products.first(limit).map { |p| { name: p['name'], url: p['url'], price: p['price'], color: p['color'], image: p['image'] } }
    end

    def scrape_product_page(product_url)
      full_url = product_url.start_with?('http') ? product_url : "#{BASE_URL}#{product_url}"

      @page.goto(full_url, waitUntil: 'domcontentloaded', timeout: 60000)
      sleep(PAGE_LOAD_DELAY)

      # Dismiss dialogs if they reappear
      dismiss_cookie_dialog
      dismiss_location_dialog

      # Extract product details
      @page.evaluate(<<~JS)
        () => {
          // Get product name from h1
          const name = document.querySelector('h1')?.textContent?.trim() || '';

          // Get price - format: "160 EUR"
          let price = 0;
          const priceMatch = document.body.innerText.match(/(\\d+)\\s*EUR/);
          if (priceMatch) {
            price = parseInt(priceMatch[1], 10);
          }

          // Get color from the product info section
          let color = 'Unknown';

          // First, try to extract from URL (most reliable)
          // URL pattern: /mens-regular-jeans-mid-blue-wash -> "Mid Blue Wash"
          // Extract everything after the product type (jeans, shirt, t-shirt, etc.)
          const productTypes = ['jeans', 'shirt', 't-shirt', 'sweater', 'hoodie', 'jacket', 'coat', 'pants', 'trousers', 'shorts', 'polo', 'cardigan', 'vest', 'sweatshirt', 'oxford', 'chino', 'knit', 'blazer', 'parka'];
          const pathParts = window.location.pathname.split('/').pop().split('-');

          for (let i = 0; i < pathParts.length; i++) {
            if (productTypes.includes(pathParts[i])) {
              // Everything after this is the color
              const colorParts = pathParts.slice(i + 1);
              if (colorParts.length > 0) {
                color = colorParts.map(w => w.charAt(0).toUpperCase() + w.slice(1)).join(' ');
              }
              break;
            }
          }

          // Fallback: look for color text displayed on page near "Color" section
          if (color === 'Unknown') {
            // Look for the color shown near color swatches
            const pageText = document.body.innerText;
            const colorPatterns = [
              /(?:^|\\n)([A-Z][a-z]+(?:\\s+[A-Z][a-z]+)*\\s+(?:Wash|Denim|Blue|Black|White|Grey|Green))(?:\\n|$)/m,
              /Mid Blue Wash|Raw Denim|Light Blue Wash|Grey Wash|Black|White|Navy|Charcoal|Olive|Camel|Brown|Beige/
            ];
            for (const pattern of colorPatterns) {
              const match = pageText.match(pattern);
              if (match) {
                color = match[1] || match[0];
                break;
              }
            }
          }

          // Get material from "Fiber composition" in Details section
          let material = 'Unknown';
          const listItems = document.querySelectorAll('li');
          listItems.forEach(li => {
            const text = li.innerText;
            if (text.includes('Fiber composition')) {
              const match = text.match(/Fiber composition[\\s\\n]+(.+)/);
              if (match) {
                material = match[1].trim();
              }
            }
          });

          // Fallback: look for % cotton/wool/etc patterns
          if (material === 'Unknown') {
            const materialMatch = document.body.innerText.match(/(\\d+%\\s*(?:organic\\s+)?(?:cotton|wool|linen|polyester|cashmere|silk)[^.\\n]*)/i);
            if (materialMatch) {
              material = materialMatch[1].trim();
            }
          }

          // Get main product image
          let image = '';
          const productImgs = document.querySelectorAll('img[alt*="Image number"]');
          if (productImgs.length > 0) {
            image = productImgs[0].src || productImgs[0].getAttribute('data-src') || '';
          }

          // Fallback: any large product image
          if (!image) {
            const imgs = document.querySelectorAll('main img');
            for (const img of imgs) {
              if (img.src && img.src.includes('asket') && !img.src.includes('icon')) {
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

    def dismiss_cookie_dialog
      begin
        accept_btn = @page.get_by_role('button', name: /agree|accept|continue/i)
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
        stay_btn = @page.get_by_role('button', name: /stay/i)
        if stay_btn.visible?(timeout: 1000)
          stay_btn.click
          sleep(0.3)
        end
      rescue StandardError
        # Dialog not present
      end
    end

    def build_product(search_info, page_details)
      name = page_details['name'].to_s.empty? ? search_info[:name] : page_details['name']

      # Use color from page details if available, otherwise from search
      color = page_details['color'].to_s == 'Unknown' ? (search_info[:color] || 'Unknown') : page_details['color']

      # Use image from search if page didn't have one
      image = page_details['image'].to_s.empty? ? search_info[:image] : page_details['image']

      # Convert EUR price to float
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
    products = AsketPlaywrightScraper.scrape(query, limit: limit, headless: headless)

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
        puts "   Price: #{product[:clothing_price]} EUR"
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

        brand = Brand.find_by(name: 'ASKET')
        unless brand
          puts "ASKET brand not found. Creating it..."
          brand = Brand.create!(
            name: 'ASKET',
            description: 'Swedish sustainable fashion brand focused on permanent essentials. Known for radical transparency, full supply chain traceability, and high-quality organic materials.',
            planet_rating: 4.5,
            people_rating: 4.5,
            animals_rating: 4.0,
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
        puts "Total ASKET products: #{ComparisonProduct.where(clothing_brand: AsketPlaywrightScraper::Scraper::BRAND_NAME).count}"
        puts "=" * 60
      else
        puts "\n" + "=" * 60
        puts "JSON Output:"
        puts "=" * 60
        puts JSON.pretty_generate(products)
      end
    end
  rescue AsketPlaywrightScraper::Error => e
    puts "\nError: #{e.message}"
    exit 1
  rescue StandardError => e
    puts "\nUnexpected error: #{e.message}"
    puts e.backtrace.first(5).join("\n")
    exit 1
  end
end
