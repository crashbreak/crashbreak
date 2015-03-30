module Crashbreak
  class ExceptionsRepository
    BASE_URL = 'http://crashbreak.herokuapp.com/api'

    def create(error_report_hash)
      JSON.parse(post_request(error_report_hash).body)['id']
    end

    def resolve(error_id)
      resolve_request error_id
    end

    private

    def post_request(error_report_hash)
      connection.post do |req|
        req.url create_request_url
        req.body = error_report_hash.to_json
        req.headers['Content-Type'] = 'application/json'
      end
    end

    def resolve_request(error_id)
      connection.put do |req|
        req.url resolve_request_url(error_id)
        req.body = { error_report: { status: :resolved } }.to_json
        req.headers['Content-Type'] = 'application/json'
      end
    end

    def connection
      Faraday.new
    end

    def create_request_url
      "#{BASE_URL}/projects/#{project_token}/errors"
    end

    def resolve_request_url(error_id)
      "#{BASE_URL}/projects/#{project_token}/errors/#{error_id}"
    end

    def project_token
      Crashbreak.configure.api_key
    end
  end
end
