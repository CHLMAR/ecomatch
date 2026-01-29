# frozen_string_literal: true

STDOUT.sync = true

require 'json'
require 'uri'
require 'playwright'

# Luisa Via Roma Simple Scraper
# Minimal two-step scraper: search page -> product pages
#
# Usage:
#   ruby lib/scrapers/luisaviaroma_scraper.rb jeans 10 women --visible
#   ruby lib/scrapers/luisaviaroma_scraper.rb t-shirt 5 men --visible
#
module LuisaViaRomaScraper
  BASE_URL = "https://www.luisaviaroma.com"

  class Scraper
    def initialize(headless: true)
      @headless = headless
    end

    def search(query, limit: 10, gender: 'women')
      puts "=" * 60
      puts "LVR Scraper: #{gender} #{query} (limit: #{limit})"
      puts "=" * 60

      products = []

      Playwright.create(playwright_cli_executable_path: 'npx playwright') do |playwright|
        @browser = playwright.chromium.launch(headless: @headless)
        context = @browser.new_context(
          viewport: { width: 1440, height: 900 },
          userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36'
        )
        @page = context.new_page

        begin
          # Step 1: Get products from search page
          url = "#{BASE_URL}/en-fr/shop/#{gender}/search?search=#{URI.encode_www_form_component(query)}"
          puts "\nNavigating to: #{url}"
          @page.goto(url, waitUntil: 'networkidle', timeout: 60000)
          sleep(8)

          # Debug: show page title
          puts "Page title: #{@page.title}"
          puts "Current URL: #{@page.url}"

          # Dismiss dialogs
          5.times { @page.keyboard.press('Escape') rescue nil; sleep(0.5) }

          # Wait longer and scroll to load products
          sleep(3)
          4.times do |i|
            @page.keyboard.press('End')
            sleep(3)
            puts "Scrolled #{i + 1}/4..."
          end

          # Debug: count links
          link_count = @page.evaluate('() => document.querySelectorAll("a").length')
          product_links = @page.evaluate('() => [...document.querySelectorAll("a")].filter(a => a.href.includes("/product/")).length')
          puts "Total links: #{link_count}, Product links: #{product_links}"

          # Extract product data directly from search page
          raw_products = @page.evaluate(<<~JS)
            () => {
              const results = [];
              const seen = new Set();

              document.querySelectorAll('a').forEach(link => {
                const href = link.href || '';
                if (!href.includes('/product/') || seen.has(href)) return;
                seen.add(href);

                // Get text content from link or parent
                let name = link.innerText?.trim() || '';
                let brand = '';

                // Try to find brand and product name
                const parent = link.closest('article') || link.parentElement?.parentElement?.parentElement;
                if (parent) {
                  const texts = parent.innerText.split('\\n').filter(t => t.trim().length > 1);
                  if (texts.length >= 2) {
                    brand = texts[0]?.trim() || '';
                    name = texts[1]?.trim() || '';
                  }
                }

                // Get price
                let price = 0;
                const priceMatch = (parent?.innerText || '').match(/€\\s*([\\d,.]+)/);
                if (priceMatch) price = parseFloat(priceMatch[1].replace(',', ''));

                // Get image
                let image = '';
                const img = link.querySelector('img') || parent?.querySelector('img');
                if (img) image = img.src || img.dataset?.src || '';

                if (name.length > 2) {
                  results.push({ name, brand, price, image, url: href });
                }
              });

              return results;
            }
          JS

          puts "Found #{raw_products.size} products on search page"

          # Step 2: Visit each product page for details
          raw_products.first(limit).each_with_index do |prod, i|
            puts "\n[#{i + 1}/#{limit}] #{prod['brand']} - #{prod['name']}"

            begin
              @page.goto(prod['url'], waitUntil: 'domcontentloaded', timeout: 30000)
              sleep(3)
              @page.keyboard.press('Escape') rescue nil

              details = @page.evaluate(<<~JS)
                () => {
                  const text = document.body.innerText;

                  // Color
                  let color = 'Unknown';
                  const colorMatch = text.match(/(?:Color|Colour)[:\\s]+([A-Za-z\\s]+?)(?:\\n|Size|€)/i);
                  if (colorMatch) color = colorMatch[1].trim();

                  // Material
                  let material = 'Unknown';
                  const matMatch = text.match(/(\\d+%\\s*[A-Za-z]+(?:[,\\s]+\\d+%\\s*[A-Za-z]+)*)/);
                  if (matMatch) material = matMatch[1].trim();

                  // Better image
                  let image = '';
                  const img = document.querySelector('img[src*="cdn-cgi"]');
                  if (img) image = img.src;

                  return { color, material, image };
                }
              JS

              products << {
                product_description: "#{gender.capitalize}'s #{prod['name']}",
                clothing_item: infer_type(query),
                clothing_material: details['material'] || 'Unknown',
                clothing_colour: details['color'] || 'Unknown',
                clothing_brand: prod['brand'] || 'Unknown',
                clothing_price: prod['price'].to_f,
                item_image: details['image'].to_s.empty? ? prod['image'] : details['image'],
                external_link: prod['url']
              }

              sleep(1.5)
            rescue => e
              puts "  Error: #{e.message}"
            end
          end
        ensure
          @browser&.close
        end
      end

      puts "\n" + "=" * 60
      puts "Scraped #{products.size} products"
      puts "=" * 60
      products
    end

    private

    def infer_type(query)
      case query.downcase
      when /jeans|denim/ then 'Pants'
      when /t-shirt|tee/ then 'T-Shirt'
      when /jacket/ then 'Jacket'
      when /shirt/ then 'Shirt'
      when /sweater|hoodie/ then 'Sweater'
      else 'Apparel'
      end
    end
  end

  def self.scrape(query, limit: 10, gender: 'women', headless: true)
    Scraper.new(headless: headless).search(query, limit: limit, gender: gender)
  end
end

# Standalone execution
if __FILE__ == $0
  query = ARGV[0] || "jeans"
  limit = (ARGV[1] || 10).to_i
  gender = ARGV.find { |a| %w[women men].include?(a.downcase) } || 'women'
  headless = !ARGV.include?('--visible')
  save_to_db = !ARGV.include?('--no-save')

  products = LuisaViaRomaScraper.scrape(query, limit: limit, gender: gender.downcase, headless: headless)

  products.each_with_index do |p, i|
    puts "\n#{i + 1}. #{p[:product_description]}"
    puts "   Brand: #{p[:clothing_brand]} | Type: #{p[:clothing_item]}"
    puts "   Material: #{p[:clothing_material]} | Color: #{p[:clothing_colour]}"
    puts "   Price: €#{p[:clothing_price]}"
  end

  if save_to_db && products.any?
    puts "\nSaving to database..."
    require_relative '../../config/environment'

    created = 0
    products.each do |p|
      next if ComparisonProduct.exists?(external_link: p[:external_link])

      brand = Brand.find_or_create_by!(name: p[:clothing_brand]) do |b|
        b.description = "#{p[:clothing_brand]} - Available at LVR"
        b.planet_rating = b.people_rating = b.animals_rating = b.overall_rating = 3.0
      end

      ComparisonProduct.create!(p.merge(brand: brand))
      puts "CREATED: #{p[:product_description]}"
      created += 1
    end
    puts "Database: #{created} created"
  end
end
