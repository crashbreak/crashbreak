module Crashbreak
  class DeploysRepository
    BASE_URL = 'http://crashbreak.herokuapp.com/api'

    def initialize(project_token, deploy_hash)
      @project_token = project_token
      @deploy_hash = deploy_hash
    end

    def create
      post_request.body
    end

    private

    def post_request
      connection.post do |req|
        req.url create_deploy_url
        req.body = @deploy_hash.to_json
        req.headers['Content-Type'] = 'application/json'
      end
    end

    def connection
      Faraday.new
    end

    def create_deploy_url
      "#{BASE_URL}/projects/#{@project_token}/deploys"
    end
  end
end
