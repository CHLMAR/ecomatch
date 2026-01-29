# frozen_string_literal: true

namespace :patagonia do
  desc "Scrape Patagonia products and create ComparisonProducts"
  task scrape: :environment do
    require_relative '../../db/patagoniascraping'

    query = ENV.fetch('QUERY', 'jacket')
    limit = ENV.fetch('LIMIT', 10).to_i
    demo_mode = ENV['DEMO'] == 'true'

    puts "=" * 60
    puts "Patagonia Product Scraper"
    puts "=" * 60
    puts "Query: #{query}"
    puts "Limit: #{limit}"
    puts "Mode: #{demo_mode ? 'DEMO' : 'LIVE'}"
    puts "-" * 60

    # Initialize scraper
    scraper = PatagoniaScraper::SearchScraper.new(require_api_key: !demo_mode)

    # Get products
    products = if demo_mode
                 scraper.get_demo_products(limit)
               else
                 scraper.search(query, limit: limit)
               end

    if products.empty?
      puts "No products found."
      exit 0
    end

    puts "Found #{products.size} products"

    # Find or create Patagonia brand
    brand = Brand.find_or_create_by!(name: "Patagonia") do |b|
      b.description = "Sustainable outdoor clothing and gear company committed to environmental responsibility"
      b.planet_rating = 4.0
      b.people_rating = 5.0
      b.animals_rating = 4.0
      b.overall_rating = 4.5
    end

    puts "Using brand: #{brand.name} (ID: #{brand.id})"

    # Create ComparisonProducts
    created = 0
    skipped = 0

    products.each do |product|
      existing = ComparisonProduct.find_by(external_link: product[:external_link])

      if existing
        puts "  SKIP: #{product[:product_description]} (already exists)"
        skipped += 1
        next
      end

      ComparisonProduct.create!(
        brand: brand,
        clothing_item: product[:clothing_item],
        clothing_material: product[:clothing_material],
        clothing_colour: product[:clothing_colour],
        clothing_brand: product[:brand],
        clothing_price: product[:clothing_price],
        item_image: product[:item_image],
        external_link: product[:external_link],
        product_description: product[:product_description]
      )

      puts "  CREATE: #{product[:product_description]}"
      created += 1
    end

    puts "-" * 60
    puts "Done! Created: #{created}, Skipped: #{skipped}"
  end

  desc "Update Patagonia product images to Cloudinary"
  task update_images: :environment do
    require 'playwright'
    require 'tempfile'
    require 'base64'

    brand = Brand.find_by(name: "Patagonia")
    unless brand
      puts "No Patagonia brand found."
      exit 1
    end

    # Find products with Patagonia URLs (not Cloudinary)
    products = ComparisonProduct.where(brand: brand)
                                .where("item_image LIKE ?", "%patagonia.com%")

    puts "=" * 60
    puts "Updating #{products.count} Patagonia product images to Cloudinary"
    puts "=" * 60

    if products.count == 0
      puts "No products need updating."
      exit 0
    end

    updated = 0
    failed = 0

    Playwright.create(playwright_cli_executable_path: 'npx playwright') do |playwright|
      browser = playwright.chromium.launch(
        headless: !ENV['VISIBLE'],
        args: ['--disable-blink-features=AutomationControlled', '--no-sandbox']
      )

      context = browser.new_context(
        viewport: { width: 1280, height: 800 },
        userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36'
      )
      page = context.new_page

      products.find_each.with_index do |product, index|
        puts "\n[#{index + 1}/#{products.count}] #{product.product_description}"
        puts "  Product URL: #{product.external_link.to_s.slice(0, 50)}..."

        begin
          # Navigate to product page
          page.goto(product.external_link, waitUntil: 'domcontentloaded', timeout: 30000)
          sleep(2)

          # Dismiss cookie dialog if present
          begin
            decline_btn = page.get_by_role('button', name: 'Decline Optional')
            decline_btn.click if decline_btn.visible?(timeout: 1000)
          rescue StandardError
            # Dialog not present
          end

          # Wait for images to render
          sleep(3)

          # Find the main product image element
          img = page.locator('picture img').first

          unless img.visible?
            puts "  FAILED: Image element not found"
            failed += 1
            next
          end

          puts "  Found image element, capturing screenshot..."

          # Take screenshot of the image element (this works even with hotlink protection)
          screenshot_data = img.screenshot(type: 'jpeg', quality: 90)

          # Save to temp file
          temp_file = Tempfile.new(['patagonia', '.jpg'])
          temp_file.binmode
          temp_file.write(screenshot_data)
          temp_file.rewind

          puts "  Uploading to Cloudinary..."
          result = Cloudinary::Uploader.upload(
            temp_file.path,
            folder: 'ecomatch/patagonia',
            public_id: product.product_description.to_s.parameterize.slice(0, 50),
            overwrite: true,
            resource_type: 'image'
          )

          temp_file.close
          temp_file.unlink

          # Update database with actual Cloudinary URL
          product.update!(item_image: result['secure_url'])
          puts "  UPLOADED: #{result['secure_url'].slice(0, 60)}..."
          updated += 1

          sleep(1.5) # Rate limiting
        rescue StandardError => e
          puts "  ERROR: #{e.message}"
          failed += 1
        end
      end

      browser.close
    end

    puts "\n" + "=" * 60
    puts "Complete! Updated: #{updated}, Failed: #{failed}"
    puts "=" * 60
  end

  desc "List all Patagonia ComparisonProducts"
  task list: :environment do
    brand = Brand.find_by(name: "Patagonia")

    if brand.nil?
      puts "No Patagonia brand found. Run `rails patagonia:scrape` first."
      exit 0
    end

    products = ComparisonProduct.where(brand: brand)
    puts "Found #{products.count} Patagonia products:\n\n"

    products.each_with_index do |p, i|
      puts "#{i + 1}. #{p.product_description}"
      puts "   Type: #{p.clothing_item} | Material: #{p.clothing_material}"
      puts "   Color: #{p.clothing_colour} | Price: $#{p.clothing_price}"
      puts "   Link: #{p.external_link}"
      puts
    end
  end
end
