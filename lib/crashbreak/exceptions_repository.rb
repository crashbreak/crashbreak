module Crashbreak
  class ExceptionsRepository
    BASE_URL = 'http://crashbreak.herokuapp.com/api'

    def create(error_report_hash)
      JSON.parse(post_request(error_report_hash).body)['id']
    end

    private

    def post_request(error_report_hash)
      connection.post do |req|
        req.url request_url
        req.body = error_report_hash.to_json
        req.headers['Content-Type'] = 'application/json'
      end
    end

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
