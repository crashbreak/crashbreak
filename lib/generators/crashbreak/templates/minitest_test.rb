require_relative 'test/test_helper.rb'

class ErrorRequestTest < ActionDispatch::IntegrationTest
  def setup
    @restorers_data = StateRestorer.new('<%= error_id %>').restore
    @request_parser = Crashbreak::RequestParser.new @restorers_data[:request]
  end

  def test_sending_request
    @request_parser.request_data do |request_method, url, body, headers|
      method(request_method).call url, body, headers
    end
  end
end
