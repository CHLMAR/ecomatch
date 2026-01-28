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
