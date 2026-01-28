require 'net/http'
require 'net/https'

class ScrapingBeeApi
  # Classic (GET )
  def send_request(uploaded_link)
    search_url = URI.encode_www_form_component(uploaded_link)
    ai_query = URI.encode_www_form_component("return JSON: clothing_item, clothing_material, clothing_colour, clothing_brand, clothing_price (number), item_image (url), item_name, item_description")
    #added js rendering
    uri = URI("https://app.scrapingbee.com/api/v1?api_key=#{SCRAPINGBEE_API_KEY}&url=#{search_url}&render_js=true&ai_query=#{ai_query}")

    # Create client
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE # TODO: Use VERIFY_PEER in production
    http.read_timeout = 60 # JS rendering can take time

    # Create Request
    req = Net::HTTP::Get.new(uri)

    # Fetch Request
    res = http.request(req)

    Rails.logger.info("ScrapingBee raw response: #{res.body}")

    if res.code == "200"
      JSON.parse(res.body)
    else
      Rails.logger.error("ScrapingBee API error: #{res.code} - #{res.body}")
      nil
    end

  rescue StandardError => e
    Rails.logger.error("ScrapingBee HTTP Request failed: #{e.message}")
    nil
  end
end
