require 'net/http'
require 'uri'
require 'openssl'

def send_request(
  search_term:,
  ai_query:,
  api_key: ENV['SCRAPINGBEE_API_KEY']
)
  raise "Missing SCRAPINGBEE_API_KEY" if api_key.nil? || api_key.empty?

  # Target Patagonia search page
  target_url = "https://www.patagonia.com/search/?q=#{search_term}"

  # ScrapingBee requires api_key and url in the query string
  uri = URI("https://app.scrapingbee.com/api/v1")
  uri.query = URI.encode_www_form(
    api_key: api_key,
    url: target_url
  )

  # POST body: AI extraction options
  body_params = {
    render_js: true,
    stealth_proxy: true,
    wait: 5000,
    block_resources: false,
    ai_query: ai_query
  }

  # Headers to mimic real browser
  headers = {
    "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36",
    "Accept-Language" => "en-US,en;q=0.9",
    "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
    "Referer" => "https://www.patagonia.com/"
  }

  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  req = Net::HTTP::Post.new(uri, headers)
  req.set_form_data(body_params)

  res = http.request(req)

  puts "Response HTTP Status Code: #{res.code}"
  body = res.body.force_encoding('UTF-8')

  File.write(
    "db/scrapingbee_test_output.txt",
    "Status: #{res.code}\n\n#{body}"
  )

  puts "Response saved to db/scrapingbee_test_output.txt"

rescue StandardError => e
  puts "HTTP Request failed (#{e.message})"
end

# Example usage
ai_query = "first 10 products listed on page, exact product title as product_description, clothing type as clothing_item, fabric material as clothing_material, main color as clothing_colour, brand Patagonia, numeric price as clothing_price, primary product image url as item_image, product detail page link as external_link"

send_request(
  search_term: "jacket",
  ai_query: ai_query
)
