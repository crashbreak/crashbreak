module Crashbreak
  class DumpersDataRepository < BaseRepository
    def initialize(error_id)
      @error_id = error_id
    end

    def dumpers_data
      JSON.parse request_body
    end

    private

    def request_body
      connection.get do |req|
        req.url request_url
        req.headers['Content-Type'] = 'application/json'
      end.body
    end

    def connection
      Faraday.new(url: request_url)
    end

    def request_url
      "#{BASE_URL}/projects/#{project_token}/errors/#{@error_id}/dumpers_data"
    end
  end
end
