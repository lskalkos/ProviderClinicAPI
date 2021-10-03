# frozen_string_literal: true

##
# This class is a client wrapper for the Zipcode API.

module ZipcodeAPI
  class Client
    BASE_URL = 'https://www.zipcodeapi.com/rest/RuO4IbtPALzhFUhg292i2QRPdFkFCB6LLWg1DoxWV6H9CAQql9T4JOANQqwWUdnT/radius.json/'

    class << self
      def client
        @client || Faraday::Connection.new(BASE_URL)
      end

      def zipcodes_within_radius(zipcode, radius, units = 'mile')
        response = client.post("#{zipcode}/#{radius}/#{units}")
        return nil unless response.success?

        JSON.parse(response.body)['zip_codes']
      end
    end
  end
end
