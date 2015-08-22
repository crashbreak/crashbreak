module Crashbreak
  class RequestRestorer
    def initialize(request_data)
      @request_data = request_data
    end

    def restore
      @request_data
    end
  end
end