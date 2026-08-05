# A wrapper for the Realtor API, reached through RapidAPI, to fetch property details.
# @see https://rapidapi.com/apidojo/api/realty-in-us
module Alt
  # Embeds the logic of a Realtor property.
  class Property
    # The RapidAPI host serving the Realtor data.
    HOST = 'realty-in-us.p.rapidapi.com'

    # @data [Hash] data the attributes of each property
    # @option data [String] address Building number, street name, and optionally unit number
    # @option data [String] unit Unit number for the property
    # @option data [String] city City in which the property is located
    # @option data [String] zipcode 5-digit US zipcode in which the property is located
    def initialize(data = {})
      @data = data
    end

    # @return [Hash] Details about the property
    def property_details = details

  private

    def details
      @details ||= fetch
    end

    # Realtor exposes no address-to-detail endpoint, so the address is resolved to an id first.
    def fetch = get '/properties/v3/detail', property_id: property_id

    def property_id
      suggestions = get('/locations/v2/auto-complete', input: input)[:autocomplete]
      raise Error if suggestions.nil? || suggestions.empty?

      suggestions.first[:mpr_id]
    end

    def input
      [@data[:address], @data[:unit], @data[:city], @data[:zipcode]]
        .reject { |part| part.to_s.empty? }.join ' '
    end

    def get(path, params)
      uri = URI "https://#{HOST}#{path}"
      uri.query = URI.encode_www_form params

      request = Net::HTTP::Get.new uri
      request['X-RapidAPI-Key'] = ENV['RAPIDAPI_KEY']
      request['X-RapidAPI-Host'] = HOST
      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(request)
      end
      raise Error unless response.is_a?(Net::HTTPSuccess)
      JSON(response.body).with_indifferent_access
    end
  end
end
