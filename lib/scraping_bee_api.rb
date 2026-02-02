require 'net/http'
require 'net/https'
require 'json'

class ScrapingBeeApi
  SCRAPINGBEE_API_KEY = ENV.fetch("SCRAPINGBEE_API_KEY")

  # Extracts product data from page using CSS selectors (more reliable than ai_query)
  def send_request(uploaded_link)
    search_url = URI.encode_www_form_component(uploaded_link)

    # CSS selectors to extract data from meta tags and common product page elements
    # og: stands for Open Graph -
    # a standard created by Facebook.
    # Most e-commerce sites include these meta tags so their products look good when shared on social media.
    # This makes them a reliable source for scraping.
    extract_rules = {
      'item_name' => 'meta[property="og:title"]@content',
      'item_description' => 'meta[property="og:description"]@content',
      'item_image' => 'meta[property="og:image"]@content',
      'page_title' => 'title' #backup: Extra context for GPT-4o --> the page title often has full product info, e.g. DOUBLE HEM SHORT SLEEVE T-SHIRT - White | ZARA United Kingdom
    }
    extract_rules_encoded = URI.encode_www_form_component(extract_rules.to_json)

    # JS rendering + stealth proxy (bypasses CAPTCHA protection system, e.g. H&M) + CSS selector extraction
    uri = URI("https://app.scrapingbee.com/api/v1?" \
              "api_key=#{SCRAPINGBEE_API_KEY}" \
              "&url=#{search_url}" \
              "&render_js=true" \
              "&stealth_proxy=true" \
              "&block_resources=false" \
              "&wait=5000" \
              "&extract_rules=#{extract_rules_encoded}")
    #Creates an HTTP client pointing to ScrapingBee's server (app.scrapingbee.com on port 443).
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE # TODO: Use VERIFY_PEER in production
    http.read_timeout = 90 # rendering time, increased due to JS rendering

    #Making the request
    req = Net::HTTP::Get.new(uri) #Creates a GET request with our full URL (including all the parameters)
    res = http.request(req) #Sends the request and stores the response in res

    #Debugging: thanks to this, we can see the issued logged directly in rails server
    Rails.logger.info "ScrapingBee Response HTTP Status Code: #{res.code}"
    Rails.logger.info "ScrapingBee Response Body: #{res.body}"

    #The codes:
    #200 = success, parse the JSON
    #500 = Server error (often CAPTCHA), logging error and returning nil
    #400 = bad request, logging error and returning nil
    if res.code == "200"
      JSON.parse(res.body)
    else
      Rails.logger.error "ScrapingBee error (#{res.code}): #{res.body}"
      nil
    end
  rescue StandardError => e
    Rails.logger.error "ScrapingBee HTTP Request failed: #{e.message}"
    nil
  end
end
