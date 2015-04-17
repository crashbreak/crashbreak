module Crashbreak
  class RequestParser
    def initialize(request_data)
      @request = request_data
    end

    def request_data
      yield(request_method_sym, request_path, request_body, request_headers)
    end

    private

    def request_method_sym
      @request['REQUEST_METHOD'].underscore.to_sym
    end

    def request_path
      @request['PATH_INFO']
    end

    def request_body
      JSON.parse(request_hash_as_string.gsub('=>', ':')).symbolize_keys
    end

    def request_hash_as_string
      @request['action_dispatch.request.request_parameters'] || '{}'
    end

    def request_headers
      {}.tap do |request_headers|
        @request.select{|key| key.start_with?('HTTP_')}.each do |key, value|
          request_headers[key.gsub('HTTP_', '')] = value
        end
      end
    end
  end
end