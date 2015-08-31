require 'spec_helper'

describe 'error id: <%= error_id %>', type: :request do

  let(:restorers_data) { Crashbreak::StateRestorer.new('<%= error_id %>').restore }
  let(:request_parser) { Crashbreak::RequestParser.new restorers_data[:request] }

  it 'sends request' do
    request_parser.request_data do |request_method, url, body, headers|
      method(request_method).call url, body, headers
    end
  end
end
