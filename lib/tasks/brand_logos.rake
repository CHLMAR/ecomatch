# frozen_string_literal: true

namespace :brands do
  desc "Upload a logo to Cloudinary for a specific brand"
  task :upload_logo, [:brand_name, :image_url] => :environment do |_t, args|
    require 'open-uri'
    require 'tempfile'

    brand_name = args[:brand_name]
    image_url = args[:image_url]

    unless brand_name && image_url
      puts "Usage: rails brands:upload_logo[\"Brand Name\",\"https://example.com/logo.png\"]"
      exit 1
    end

    brand = Brand.find_by(name: brand_name)
    unless brand
      puts "Brand '#{brand_name}' not found"
      exit 1
    end

    puts "Uploading logo for #{brand.name}..."

    begin
      # Download image to temp file
      extension = File.extname(URI.parse(image_url).path).presence || '.png'
      temp_file = Tempfile.new(['brand_logo', extension])
      temp_file.binmode

      URI.open(image_url, 'rb') do |remote_file|
        temp_file.write(remote_file.read)
      end
      temp_file.rewind

      # Upload to Cloudinary
      result = Cloudinary::Uploader.upload(
        temp_file.path,
        folder: "#{Rails.env}/brand_logos",
        public_id: brand.name.parameterize,
        overwrite: true,
        resource_type: 'image'
      )

      temp_file.close
      temp_file.unlink

      # Update brand record
      brand.update!(logo: result['secure_url'])
      puts "SUCCESS: #{result['secure_url']}"
    rescue StandardError => e
      puts "ERROR: #{e.message}"
      exit 1
    end
  end

  desc "Upload logo from local file path"
  task :upload_logo_file, [:brand_name, :file_path] => :environment do |_t, args|
    brand_name = args[:brand_name]
    file_path = args[:file_path]

    unless brand_name && file_path
      puts "Usage: rails brands:upload_logo_file[\"Brand Name\",\"/path/to/logo.png\"]"
      exit 1
    end

    brand = Brand.find_by(name: brand_name)
    unless brand
      puts "Brand '#{brand_name}' not found"
      exit 1
    end

    unless File.exist?(file_path)
      puts "File not found: #{file_path}"
      exit 1
    end

    puts "Uploading logo for #{brand.name} from #{file_path}..."

    begin
      result = Cloudinary::Uploader.upload(
        file_path,
        folder: "#{Rails.env}/brand_logos",
        public_id: brand.name.parameterize,
        overwrite: true,
        resource_type: 'image'
      )

      brand.update!(logo: result['secure_url'])
      puts "SUCCESS: #{result['secure_url']}"
    rescue StandardError => e
      puts "ERROR: #{e.message}"
      exit 1
    end
  end

  desc "List all brands and their logo status"
  task list_logos: :environment do
    brands = Brand.order(:name).distinct
    with_logo = 0
    without_logo = 0

    puts "=" * 70
    puts "Brand Logo Status"
    puts "=" * 70

    brands.each do |brand|
      if brand.logo.present?
        puts "✓ #{brand.name}"
        puts "  #{brand.logo}"
        with_logo += 1
      else
        puts "✗ #{brand.name} - NO LOGO"
        without_logo += 1
      end
    end

    puts "-" * 70
    puts "With logo: #{with_logo} | Without logo: #{without_logo}"
  end
end
