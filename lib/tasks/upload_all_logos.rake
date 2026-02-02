# frozen_string_literal: true

namespace :brands do
  desc "Upload all brand logos to Cloudinary from URLs"
  task upload_all_logos: :environment do
    require 'open-uri'
    require 'tempfile'

    # Logo URLs from Wikimedia Commons (most reliable, freely available)
    # Format: https://upload.wikimedia.org/wikipedia/commons/thumb/[path]/[width]px-[filename].png
    logo_urls = {
      # Major brands with Wikimedia logos
      "Patagonia" => "https://upload.wikimedia.org/wikipedia/commons/thumb/1/15/Patagonia_%28Unternehmen%29_logo.svg/500px-Patagonia_%28Unternehmen%29_logo.svg.png",
      "Nike" => "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Logo_NIKE.svg/500px-Logo_NIKE.svg.png",
      "Adidas" => "https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Adidas_Logo.svg/500px-Adidas_Logo.svg.png",
      "H&M" => "https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/H%26M-Logo.svg/500px-H%26M-Logo.svg.png",
      "Zara" => "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fd/Zara_Logo.svg/500px-Zara_Logo.svg.png",
      "Levi's" => "https://upload.wikimedia.org/wikipedia/commons/thumb/7/75/Levi%27s_logo.svg/500px-Levi%27s_logo.svg.png",
      "Uniqlo" => "https://upload.wikimedia.org/wikipedia/commons/thumb/9/92/UNIQLO_logo.svg/500px-UNIQLO_logo.svg.png",
      "Lululemon" => "https://upload.wikimedia.org/wikipedia/commons/thumb/2/22/Lululemon_Athletica_logo.svg/500px-Lululemon_Athletica_logo.svg.png",
      "GAP" => "https://upload.wikimedia.org/wikipedia/commons/thumb/6/69/Gap_logo.svg/500px-Gap_logo.svg.png",
      "ASOS" => "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/ASOS_logo.svg/500px-ASOS_logo.svg.png",
      "Mango" => "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1a/Mango_%28clothing%29_logo.svg/500px-Mango_%28clothing%29_logo.svg.png",
      "Urban Outfitters" => "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Urban_Outfitters_logo.svg/500px-Urban_Outfitters_logo.svg.png",
      "Forever 21" => "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c2/Forever_21_logo.svg/500px-Forever_21_logo.svg.png",
      "Primark" => "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6c/Primark_logo.svg/500px-Primark_logo.svg.png",
      "Anthropologie" => "https://upload.wikimedia.org/wikipedia/commons/thumb/9/91/Anthropologie_Logo.svg/500px-Anthropologie_Logo.svg.png",
      "Boohoo" => "https://upload.wikimedia.org/wikipedia/commons/thumb/d/db/Boohoo_2020_logo.svg/500px-Boohoo_2020_logo.svg.png",
      "American Eagle" => "https://upload.wikimedia.org/wikipedia/commons/thumb/9/99/American_Eagle_Outfitters_logo.svg/500px-American_Eagle_Outfitters_logo.svg.png",
      "Abercrombie & Fitch" => "https://upload.wikimedia.org/wikipedia/commons/thumb/7/78/Abercrombie_%26_Fitch_logo.svg/500px-Abercrombie_%26_Fitch_logo.svg.png",
      "Victoria's Secret" => "https://upload.wikimedia.org/wikipedia/commons/thumb/e/eb/Victoria%27s_Secret_2023.svg/500px-Victoria%27s_Secret_2023.svg.png",
      "Topshop" => "https://upload.wikimedia.org/wikipedia/commons/thumb/3/38/Topshop_logo.svg/500px-Topshop_logo.svg.png",
      "Bershka" => "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a9/Bershka_logo.svg/500px-Bershka_logo.svg.png",
      "Fashion Nova" => "https://upload.wikimedia.org/wikipedia/commons/thumb/7/70/Fashion_Nova_Logo.svg/500px-Fashion_Nova_Logo.svg.png",
      "SHEIN" => "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d2/Shein_logo.svg/500px-Shein_logo.svg.png",

      # Additional brands - using alternative sources
      "TEMU" => "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8f/Temu_logo.svg/500px-Temu_logo.svg.png",
      "MUD Jeans" => "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4e/MUD_Jeans_logo.svg/500px-MUD_Jeans_logo.svg.png",

      # Brands that may need manual handling (no Wikimedia logo available)
      # These will be skipped if URL doesn't work
      "ASKET" => nil,
      "Kotn" => nil,
      "Etiko" => nil,
      "EcoWear" => nil,
      "Brandy Melville" => nil,
      "Cider" => nil,
      "Princess Polly" => nil,
      "Romwe" => nil,
      "Missguided" => nil,
      "Nasty Gal" => nil,
      "Zaful" => nil,
      "YesStyle" => nil
    }

    puts "=" * 70
    puts "Uploading Brand Logos to Cloudinary"
    puts "=" * 70

    uploaded = 0
    failed = 0
    skipped = 0

    delay = ENV.fetch('DELAY', 3).to_i # Default 3 second delay between requests

    Brand.select(:name).distinct.order(:name).pluck(:name).each do |brand_name|
      puts "\n[#{brand_name}]"

      # Check if any brand with this name already has a logo
      if Brand.where(name: brand_name).where.not(logo: [nil, '']).exists?
        puts "  SKIP: Already has logo"
        skipped += 1
        next
      end

      logo_url = logo_urls[brand_name]

      if logo_url.nil?
        puts "  SKIP: No logo URL configured"
        skipped += 1
        next
      end

      begin
        puts "  Downloading from Wikimedia..."

        # Download image to temp file
        temp_file = Tempfile.new(['brand_logo', '.png'])
        temp_file.binmode

        URI.open(logo_url, 'rb',
                 "User-Agent" => "EcomatchBot/1.0 (sustainable fashion search engine; contact@ecomatch.com)") do |remote_file|
          temp_file.write(remote_file.read)
        end
        temp_file.rewind

        puts "  Uploading to Cloudinary..."

        # Upload to Cloudinary
        result = Cloudinary::Uploader.upload(
          temp_file.path,
          folder: "#{Rails.env}/brand_logos",
          public_id: brand_name.parameterize,
          overwrite: true,
          resource_type: 'image'
        )

        temp_file.close
        temp_file.unlink

        # Update all brand records with this name
        Brand.where(name: brand_name).update_all(logo: result['secure_url'])
        puts "  SUCCESS: #{result['secure_url']}"
        uploaded += 1

        # Delay to avoid rate limiting
        puts "  Waiting #{delay}s..."
        sleep(delay)
      rescue OpenURI::HTTPError => e
        puts "  HTTP ERROR: #{e.message}"
        failed += 1
        sleep(delay) # Wait even on error
      rescue StandardError => e
        puts "  ERROR: #{e.class} - #{e.message}"
        failed += 1
      end
    end

    puts "\n" + "=" * 70
    puts "Complete!"
    puts "Uploaded: #{uploaded} | Failed: #{failed} | Skipped: #{skipped}"
    puts "=" * 70
  end

  desc "Upload a single brand logo from URL"
  task :upload_single_logo, [:brand_name, :url] => :environment do |_t, args|
    require 'open-uri'
    require 'tempfile'

    brand_name = args[:brand_name]
    url = args[:url]

    unless brand_name && url
      puts "Usage: rails brands:upload_single_logo[\"Brand Name\",\"https://url/to/logo.png\"]"
      exit 1
    end

    brand = Brand.find_by(name: brand_name)
    unless brand
      puts "Brand '#{brand_name}' not found in database"
      exit 1
    end

    puts "Downloading logo for #{brand_name}..."

    begin
      temp_file = Tempfile.new(['brand_logo', '.png'])
      temp_file.binmode

      URI.open(url, 'rb',
               "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)") do |remote_file|
        temp_file.write(remote_file.read)
      end
      temp_file.rewind

      puts "Uploading to Cloudinary..."

      result = Cloudinary::Uploader.upload(
        temp_file.path,
        folder: "#{Rails.env}/brand_logos",
        public_id: brand_name.parameterize,
        overwrite: true,
        resource_type: 'image'
      )

      temp_file.close
      temp_file.unlink

      Brand.where(name: brand_name).update_all(logo: result['secure_url'])
      puts "SUCCESS: #{result['secure_url']}"
    rescue StandardError => e
      puts "ERROR: #{e.message}"
      exit 1
    end
  end

  desc "Capture brand logo from website using Playwright"
  task :capture_logo, [:brand_name, :website_url, :selector] => :environment do |_t, args|
    require 'playwright'
    require 'tempfile'

    brand_name = args[:brand_name]
    website_url = args[:website_url]
    selector = args[:selector] || 'header img, .logo img, [class*="logo"] img, a[href="/"] img'

    unless brand_name && website_url
      puts "Usage: rails brands:capture_logo[\"Brand Name\",\"https://brand.com\",\"optional css selector\"]"
      exit 1
    end

    brand = Brand.find_by(name: brand_name)
    unless brand
      puts "Brand '#{brand_name}' not found in database"
      exit 1
    end

    puts "Capturing logo for #{brand_name} from #{website_url}..."

    Playwright.create(playwright_cli_executable_path: 'npx playwright') do |playwright|
      browser = playwright.chromium.launch(
        headless: !ENV['VISIBLE'],
        args: ['--disable-blink-features=AutomationControlled', '--no-sandbox']
      )

      context = browser.new_context(
        viewport: { width: 1280, height: 800 },
        user_agent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36'
      )
      page = context.new_page

      begin
        page.goto(website_url, wait_until: 'domcontentloaded', timeout: 30_000)
        sleep(3)

        # Try to find logo element
        logo_element = page.locator(selector).first
        unless logo_element.visible?(timeout: 5000)
          puts "Logo element not found with selector: #{selector}"
          browser.close
          exit 1
        end

        puts "Found logo element, capturing screenshot..."
        screenshot_data = logo_element.screenshot(type: 'png')

        temp_file = Tempfile.new(['brand_logo', '.png'])
        temp_file.binmode
        temp_file.write(screenshot_data)
        temp_file.rewind

        puts "Uploading to Cloudinary..."

        result = Cloudinary::Uploader.upload(
          temp_file.path,
          folder: "#{Rails.env}/brand_logos",
          public_id: brand_name.parameterize,
          overwrite: true,
          resource_type: 'image'
        )

        temp_file.close
        temp_file.unlink

        Brand.where(name: brand_name).update_all(logo: result['secure_url'])
        puts "SUCCESS: #{result['secure_url']}"
      rescue StandardError => e
        puts "ERROR: #{e.message}"
      ensure
        browser.close
      end
    end
  end
end
