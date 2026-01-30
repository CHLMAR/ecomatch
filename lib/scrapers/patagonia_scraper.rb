# frozen_string_literal: true

require 'json'
require 'uri'
require 'net/http'
require 'tempfile'
require 'playwright'

# Patagonia Playwright Scraper
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
#   ruby lib/scrapers/patagonia_scraper.rb [query] [limit] [--visible] [--no-save]
#   ruby lib/scrapers/patagonia_scraper.rb t-shirt 15 --visible
#   ruby lib/scrapers/patagonia_scraper.rb jacket 10 --visible --no-save
#
# By default, saves scraped products to the database. Use --no-save to skip.
#
module PatagoniaPlaywrightScraper
  BASE_URL = "https://www.patagonia.com"

  # Delays to avoid detection
  PAGE_LOAD_DELAY = 2.0
  BETWEEN_PRODUCTS_DELAY = 1.5

  # Clothing type inference map
  CLOTHING_TYPE_INFERENCE = {
    /jacket|coat|parka|anorak/i => "Jacket",
    /sweater|hoodie|pullover|hoody/i => "Sweater",
    /t-shirt|tee|tank/i => "T-Shirt",
    /shirt|button/i => "Shirt",
    /pants|trousers|jeans/i => "Pants",
    /shorts|baggies/i => "Shorts",
    /vest/i => "Vest",
    /dress|skirt/i => "Dress",
    /hat|cap|beanie/i => "Hat",
    /gloves|mittens/i => "Gloves",
    /socks/i => "Socks",
    /base layer|thermal/i => "Base Layer",
    /fleece/i => "Fleece"
  }.freeze

  class Error < StandardError; end

  class Scraper
    BRAND_NAME = "Patagonia"

    def initialize(headless: true, upload_images: false)
      @headless = headless
      @upload_images = upload_images
      @browser = nil
      @page = nil
    end

    # Main entry point - search and scrape products
    def search(query, limit: 10)
      puts "=" * 60
      puts "Patagonia Playwright Scraper"
      puts "=" * 60
      puts "\nQuery: '#{query}' | Limit: #{limit}"
      puts "Mode: #{@headless ? 'Headless' : 'Visible browser'}"
      puts "-" * 60

      products = []

      Playwright.create(playwright_cli_executable_path: find_playwright_cli) do |playwright|
        # Launch with anti-detection settings
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

    def scrape_search_page(query, limit)
      encoded_query = URI.encode_www_form_component(query)
      url = "#{BASE_URL}/search/?q=#{encoded_query}"

      puts "Navigating to: #{url}"
      @page.goto(url, waitUntil: 'domcontentloaded', timeout: 60000)
      sleep(PAGE_LOAD_DELAY + 3)  # Extra time for JS to render products

      # Debug: show current URL and title
      puts "Current URL: #{@page.url}"
      puts "Page title: #{@page.title}"

      # Handle cookie consent if present
      dismiss_cookie_dialog

      # Wait for product elements to appear
      begin
        @page.wait_for_selector('a[href*="/product/"]', timeout: 10000)
      rescue StandardError
        puts "Warning: No product links found after waiting"
        # Debug: check what's on the page
        link_count = @page.evaluate('() => document.querySelectorAll("a").length')
        puts "Debug: Found #{link_count} total links on page"
      end

      # Extract product links
      products = @page.evaluate(<<~JS)
        () => {
          const products = [];
          const seen = new Set();
          const links = document.querySelectorAll('a[href*="/product/"][href$=".html"]');

          links.forEach(link => {
            const href = link.getAttribute('href');
            const baseUrl = href.split('?')[0];
            if (seen.has(baseUrl)) return;
            seen.add(baseUrl);

            const title = link.getAttribute('title') || link.getAttribute('aria-label');
            if (!title) return;

            // Clean title - extract product name
            let name = title;
            const match = title.match(/^(.+?)\\s*-\\s*[^(]+\\s*\\([^)]+\\)\\s*\\(\\d+\\)$/);
            if (match) {
              name = match[1].trim();
            } else {
              name = title.replace(/\\s*\\(\\d+\\)\\s*$/, '').trim();
            }

            products.push({ name, url: baseUrl });
          });

          return products;
        }
      JS

      products.first(limit).map { |p| { name: p['name'], url: p['url'] } }
    end

    def scrape_product_page(product_url)
      full_url = product_url.start_with?('http') ? product_url : "#{BASE_URL}#{product_url}"

      @page.goto(full_url, waitUntil: 'domcontentloaded')
      sleep(PAGE_LOAD_DELAY)

      # Dismiss cookie dialog if it reappears
      dismiss_cookie_dialog

      # Click "Materials & Care Instructions" to expand
      begin
        materials_btn = @page.get_by_role('button', name: 'Materials & Care Instructions')
        if materials_btn.visible?(timeout: 2000)
          materials_btn.click
          sleep(0.5)
        end
      rescue StandardError
        # Button might not exist or already expanded
      end

      # Extract product details
      @page.evaluate(<<~JS)
        () => {
          // Get product name
          const name = document.querySelector('h1')?.textContent?.trim() || '';

          // Get price - look for the main price display
          let price = 0;
          const priceMatch = document.body.innerText.match(/\\$(\\d+)(?:\\.\\d{2})?/);
          if (priceMatch) {
            price = parseInt(priceMatch[1], 10);
          }

          // Get selected color
          let color = 'Unknown';
          const colorMatch = document.body.innerText.match(/Color\\s+([A-Za-z\\s]+?)(?=\\n|Size|$)/);
          if (colorMatch) {
            color = colorMatch[1].trim();
          }

          // Get material from expanded Materials section
          let material = 'Unknown';
          document.querySelectorAll('li p').forEach(p => {
            const text = p.textContent;
            if (text && (text.includes('oz') || text.includes('%')) && !text.includes('Machine Wash')) {
              material = text.trim();
            }
          });

          // Get main product image from <picture><source> elements (real images are in srcset)
          let image = '';

          // Priority 1: Find first <source> with hi-res product image in srcset
          const sources = document.querySelectorAll('picture source');
          for (const source of sources) {
            const srcset = source.getAttribute('srcset') || '';
            // Look for product images (Sites-patagonia-master with hi-res)
            if (srcset.includes('Sites-patagonia-master') && srcset.includes('hi-res') && srcset.includes('.jpg')) {
              // Extract the first URL from srcset (format: "url 512w, url 1024w, ...")
              const firstUrl = srcset.split(',')[0].split(' ')[0];
              if (firstUrl) {
                // Get a good quality version
                image = firstUrl.split('?')[0] + '?sw=800&sh=800&sfrm=jpg&q=90';
                break;
              }
            }
          }

          // Fallback: try JSON-LD schema which also contains product images
          if (!image) {
            const jsonLd = document.querySelector('script[type="application/ld+json"]');
            if (jsonLd) {
              try {
                const data = JSON.parse(jsonLd.textContent);
                if (data.image && data.image.includes('hi-res')) {
                  image = data.image;
                }
              } catch (e) {}
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
        decline_btn = @page.get_by_role('button', name: 'Decline Optional')
        if decline_btn.visible?(timeout: 1000)
          decline_btn.click
          sleep(0.3)
        end
      rescue StandardError
        # Dialog not present
      end
    end

    def build_product(search_info, page_details)
      name = page_details['name'].to_s.empty? ? search_info[:name] : page_details['name']

      # Get image URL - upload to Cloudinary if enabled
      original_image_url = ensure_absolute_url(page_details['image'])
      item_image = if @upload_images && !original_image_url.empty?
                     upload_image_to_cloudinary(original_image_url, name) || original_image_url
                   else
                     original_image_url
                   end

      {
        product_description: name,
        clothing_item: infer_clothing_type(name),
        clothing_material: page_details['material'] || 'Unknown',
        clothing_colour: page_details['color'] || 'Unknown',
        clothing_brand: BRAND_NAME,
        clothing_price: page_details['price'].to_f,
        item_image: item_image,
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

    # Download image from Patagonia using browser (bypasses hotlink protection)
    # and upload to Cloudinary
    def upload_image_to_cloudinary(image_url, product_name)
      return nil if image_url.nil? || image_url.empty?

      begin
        puts "    Downloading image..."

        # Use page to download image (has proper cookies/headers)
        image_data = @page.evaluate(<<~JS, image_url)
          async (url) => {
            try {
              const response = await fetch(url);
              if (!response.ok) return null;
              const blob = await response.blob();
              return new Promise((resolve) => {
                const reader = new FileReader();
                reader.onloadend = () => resolve(reader.result);
                reader.readAsDataURL(blob);
              });
            } catch (e) {
              return null;
            }
          }
        JS

        return nil unless image_data&.start_with?('data:image')

        # Extract base64 data and save to temp file
        base64_data = image_data.split(',')[1]
        return nil unless base64_data

        temp_file = Tempfile.new(['patagonia', '.jpg'])
        temp_file.binmode
        temp_file.write(Base64.decode64(base64_data))
        temp_file.rewind

        # Upload to Cloudinary
        puts "    Uploading to Cloudinary..."
        result = Cloudinary::Uploader.upload(
          temp_file.path,
          folder: 'ecomatch/patagonia',
          public_id: product_name.to_s.parameterize.slice(0, 50),
          overwrite: true,
          resource_type: 'image'
        )

        temp_file.close
        temp_file.unlink

        cloudinary_url = result['secure_url']
        puts "    Uploaded: #{cloudinary_url.slice(0, 60)}..."
        cloudinary_url
      rescue StandardError => e
        puts "    Image upload failed: #{e.message}"
        nil
      end
    end
  end

  # Convenience method for Rails integration
  def self.scrape(query, limit: 10, headless: true, upload_images: false)
    scraper = Scraper.new(headless: headless, upload_images: upload_images)
    scraper.search(query, limit: limit)
  end
end

# Standalone execution
if __FILE__ == $0
  query = ARGV[0] || "t-shirt"
  limit = (ARGV[1] || 10).to_i
  headless = !ARGV.include?('--visible')
  save_to_db = !ARGV.include?('--no-save')
  upload_images = ARGV.include?('--upload-images')

  begin
    products = PatagoniaPlaywrightScraper.scrape(query, limit: limit, headless: headless, upload_images: upload_images)

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

        brand = Brand.find_by(name: 'Patagonia')
        unless brand
          puts "ERROR: Patagonia brand not found in database. Run rails db:seed first."
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
        puts "Total Patagonia products: #{ComparisonProduct.where(clothing_brand: 'Patagonia').count}"
        puts "=" * 60
      else
        puts "\n" + "=" * 60
        puts "JSON Output:"
        puts "=" * 60
        puts JSON.pretty_generate(products)
      end
    end
  rescue PatagoniaPlaywrightScraper::Error => e
    puts "\nError: #{e.message}"
    exit 1
  rescue StandardError => e
    puts "\nUnexpected error: #{e.message}"
    puts e.backtrace.first(5).join("\n")
    exit 1
  end
end
