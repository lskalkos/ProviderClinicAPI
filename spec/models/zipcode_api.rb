# frozen_string_literal: true

class ZipcodeApi
  BASE_URL = 'https://www.zipcodeapi.com/rest/DemoOnly00w1sGKQtL6PsMin0SxGXceg663wRZo6ARQ5uxHbJlrR8dNA20UALtye'

  class << self
    def connection
      @connection ||= Faraday::Connection.new(BASE_URL)
    end

    def zipcodes_within_radius(zipcode, radius, units = 'mile')
      response = connection.post("/radius.json/#{zipcode}/#{radius}/#{units}")
      return nil unless response.success?

      JSON.parse(response.body)
    end
  end
end
