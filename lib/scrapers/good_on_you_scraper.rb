# frozen_string_literal: true

require 'json'
require 'playwright'

# Good On You Sustainability Rating Scraper
# Scrapes brand sustainability ratings from directory.goodonyou.eco
#
# Requirements:
#   gem install playwright-ruby-client
#   npx playwright install chromium
#
# Usage:
#   ruby lib/scrapers/good_on_you_scraper.rb
#   ruby lib/scrapers/good_on_you_scraper.rb --visible
#
# Returns integer ratings (1-5) for:
#   - Planet rating
#   - People rating
#   - Animals rating
#   - Overall rating
#
module GoodOnYouScraper
  BASE_URL = "https://directory.goodonyou.eco"

  # Delays to avoid detection
  PAGE_LOAD_DELAY = 2.0
  BETWEEN_BRANDS_DELAY = 1.5

  # Overall rating text to integer mapping
  OVERALL_RATING_MAP = {
    "we avoid" => 1,
    "not good enough" => 2,
    "it's a start" => 3,
    "good" => 4,
    "great" => 5
  }.freeze

  # Target fast fashion brands with their URL slugs
  TARGET_BRANDS = {
    "Shein" => "shein",
    "Temu" => "temu",
    "Zara" => "zara",
    "H&M" => "h-and-m",
    "Boohoo" => "boohoo",
    "Fashion Nova" => "fashion-nova",
    "Forever 21" => "forever-21",
    "Uniqlo" => "uniqlo",
    "Mango" => "mango",
    "ASOS" => "asos",
    "Primark" => "primark",
    "Topshop" => "topshop",
    "Missguided" => "missguided",
    "Nasty Gal" => "nasty-gal",
    "Cider" => "cider",
    "Zaful" => "zaful",
    "Romwe" => "romwe",
    "Urban Outfitters" => "urban-outfitters",
    "Anthropologie" => "anthropologie",
    "Brandy Melville" => "brandy-melville",
    "Princess Polly" => "princess-polly",
    "YesStyle" => "yesstyle",
    "Abercrombie & Fitch" => "abercrombie-and-fitch",
    "American Eagle" => "american-eagle",
    "Victoria's Secret" => "victorias-secret",
    "GAP" => "gap",
    "Nike" => "nike",
    "Adidas" => "adidas",
    "Bershka" => "bershka"
  }.freeze

  class Error < StandardError; end

  class Scraper
    def initialize(headless: true)
      @headless = headless
      @browser = nil
      @page = nil
    end

    # Main entry point - scrape all target brands
    def scrape_all
      puts "=" * 60
      puts "Good On You Sustainability Rating Scraper"
      puts "=" * 60
      puts "\nTarget brands: #{TARGET_BRANDS.keys.join(', ')}"
      puts "Mode: #{@headless ? 'Headless' : 'Visible browser'}"
      puts "-" * 60

      ratings = []

      Playwright.create(playwright_cli_executable_path: find_playwright_cli) do |playwright|
        @browser = playwright.chromium.launch(
          headless: @headless,
          args: [
            '--disable-blink-features=AutomationControlled',
            '--no-sandbox',
            '--disable-dev-shm-usage'
          ]
        )

        context = @browser.new_context(
          viewport: { width: 1280, height: 800 },
          userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36',
          locale: 'en-US'
        )
        @page = context.new_page

        begin
          TARGET_BRANDS.each_with_index do |(brand_name, slug), index|
            puts "\n[#{index + 1}/#{TARGET_BRANDS.size}] Scraping #{brand_name}..."

            brand_ratings = scrape_brand(slug)
            brand_ratings[:name] = brand_name
            brand_ratings[:slug] = slug

            ratings << brand_ratings

            puts "  Planet: #{brand_ratings[:planet_rating]}/5"
            puts "  People: #{brand_ratings[:people_rating]}/5"
            puts "  Animals: #{brand_ratings[:animals_rating]}/5"
            puts "  Overall: #{brand_ratings[:overall_rating]}/5"

            sleep(BETWEEN_BRANDS_DELAY) if index < TARGET_BRANDS.size - 1
          end
        ensure
          @browser&.close
        end
      end

      puts "\n" + "=" * 60
      puts "Completed: #{ratings.size} brands scraped"
      puts "=" * 60

      ratings
    end

    # Scrape a single brand by slug
    def scrape_brand(slug)
      url = "#{BASE_URL}/brand/#{slug}"

      @page.goto(url, waitUntil: 'domcontentloaded', timeout: 30000)
      sleep(PAGE_LOAD_DELAY)

      # Extract ratings from the page
      @page.evaluate(<<~JS)
        () => {
          const result = {
            planet_rating: 0,
            people_rating: 0,
            animals_rating: 0,
            overall_rating: 0
          };

          // Find the rating sections by their headings
          const headings = document.querySelectorAll('h4');

          headings.forEach(h4 => {
            const text = h4.textContent.trim().toLowerCase();
            const parent = h4.closest('[class*="generic"]') || h4.parentElement?.parentElement;

            if (parent) {
              // Look for "X out of 5" text nearby
              const ratingText = parent.textContent;
              const match = ratingText.match(/(\\d)\\s*out\\s*of\\s*5/i);

              if (match) {
                const rating = parseInt(match[1], 10);
                if (text.includes('planet')) {
                  result.planet_rating = rating;
                } else if (text.includes('people')) {
                  result.people_rating = rating;
                } else if (text.includes('animal')) {
                  result.animals_rating = rating;
                }
              }
            }
          });

          // Find overall rating from "Rated: X" or "Overall rating: X"
          const bodyText = document.body.innerText.toLowerCase();

          // Look for overall rating text patterns
          const overallPatterns = [
            /overall rating:\s*(we avoid|not good enough|it's a start|good|great)/i,
            /rated:\s*(we avoid|not good enough|it's a start|good|great)/i
          ];

          for (const pattern of overallPatterns) {
            const match = bodyText.match(pattern);
            if (match) {
              const ratingText = match[1].toLowerCase();
              const ratingMap = {
                "we avoid": 1,
                "not good enough": 2,
                "it's a start": 3,
                "good": 4,
                "great": 5
              };
              result.overall_rating = ratingMap[ratingText] || 0;
              break;
            }
          }

          return result;
        }
      JS
    rescue StandardError => e
      puts "    Error scraping #{slug}: #{e.message}"
      { planet_rating: 0, people_rating: 0, animals_rating: 0, overall_rating: 0 }
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
  end

  # Convenience method
  def self.scrape(headless: true)
    scraper = Scraper.new(headless: headless)
    scraper.scrape_all
  end

  # Generate seeds code from scraped ratings
  def self.generate_seeds_code(ratings)
    puts "\n" + "=" * 60
    puts "SEEDS CODE (copy to db/seeds.rb):"
    puts "=" * 60 + "\n\n"

    ratings.each do |r|
      var_name = r[:name].downcase.gsub(/[^a-z0-9]/, '_').gsub(/_+/, '_').gsub(/^_|_$/, '') + "_brand"
      puts <<~RUBY
        #{var_name} = Brand.find_or_create_by!(name: "#{r[:name]}") do |b|
          b.description = "Fast fashion brand rated by Good On You."
          b.planet_rating = #{r[:planet_rating]}
          b.people_rating = #{r[:people_rating]}
          b.animals_rating = #{r[:animals_rating]}
          b.overall_rating = #{r[:overall_rating]}
        end
        puts "Brand: \#{#{var_name}.name}"

      RUBY
    end
  end
end

# Standalone execution
if __FILE__ == $0
  headless = !ARGV.include?('--visible')

  begin
    ratings = GoodOnYouScraper.scrape(headless: headless)

    if ratings.empty?
      puts "\nNo ratings found."
    else
      puts "\n" + "=" * 60
      puts "RESULTS SUMMARY"
      puts "=" * 60

      puts "\n%-15s %6s %6s %7s %7s" % ["Brand", "Planet", "People", "Animals", "Overall"]
      puts "-" * 45
      ratings.each do |r|
        puts "%-15s %6d %6d %7d %7d" % [r[:name], r[:planet_rating], r[:people_rating], r[:animals_rating], r[:overall_rating]]
      end

      # Generate seeds code
      GoodOnYouScraper.generate_seeds_code(ratings)

      # Output JSON
      puts "\n" + "=" * 60
      puts "JSON Output:"
      puts "=" * 60
      puts JSON.pretty_generate(ratings)
    end
  rescue GoodOnYouScraper::Error => e
    puts "\nError: #{e.message}"
    exit 1
  rescue StandardError => e
    puts "\nUnexpected error: #{e.message}"
    puts e.backtrace.first(5).join("\n")
    exit 1
  end
end
