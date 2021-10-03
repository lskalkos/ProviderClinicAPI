# frozen_string_literal: true

##
# This class is a client wrapper for the Zipcode API.
# I like using wrapper class that act as clients for external APIs.
# Because the interaction is encapsulated, we can then use the wrapper throughout
# the codebase and only have one location where the interface is managed. This
# also makes it easy to change things if the API is updated or deprecated.

module ZipcodeAPI
  class Client
    # I think AWS Secrets Manager is probably a better location to store credentials,
    # rather than as an environment variable (which still requires some secure way of getting them there)
    # or as Rails encrypted credentials which still requires uploading secrets to version control,
    # but for now we'll use Rails encrypted credentials.
    API_KEY = Rails.application.credentials.zipcode_api[:api_key]
    BASE_URL = "https://www.zipcodeapi.com/rest/#{API_KEY}/radius.json/"

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
