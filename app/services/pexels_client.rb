class PexelsClient
  BASE_URL = "https://api.pexels.com/v1"

  class Error < StandardError
  end

  def initialize(api_key: Rails.application.credentials.dig(:pexels, :api_key))
    @api_key = api_key

    raise Error, "Missing Pexels API key" if @api_key.blank?

    @connection = Faraday.new(url: BASE_URL) do |faraday|
      faraday.headers["Authorization"] = @api_key
      faraday.adapter Faraday.default_adapter
    end
  end

  def collection_photos(collection_id)
    response = @connection.get("collections/#{collection_id}", {
      type: "photos",
      per_page: 24
    })

    body = JSON.parse(response.body)

    if response.status == 200
      body.fetch("media", [])
    else
      raise Error, body["error"] || "Pexels request failed"
    end
  rescue Faraday::Error => e
    raise Error, "Connection error: #{e.message}"
  rescue JSON::ParserError
    raise Error, "Could not read the Pexels response"
  end
end
