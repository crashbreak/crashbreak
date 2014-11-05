module Crashbreak
  class ExceptionsRepository
    BASE_URL = 'http://crashbreak.herokuapp.com'

    def create(error_report_hash)
      connection.post request_url, error_report_hash.to_json
    end

    private

    def connection
      Faraday.new(url: request_url)
    end

    def request_url
      "#{BASE_URL}/projects/#{project_token}/errors"
    end

    def project_token
      Crashbreak.configure.api_key
    end
  end
end
