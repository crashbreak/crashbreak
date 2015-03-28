describe Crashbreak::RequestParser do
  subject { described_class.new request_data }

  context 'simple get without headers' do
    let(:request_data) { Hash['REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/projects' ]}

    it 'yields with request data' do
      expect{|y| subject.request_data(&y) }.to yield_with_args(:get, '/projects', {}, {})
    end
  end

  context 'get with headers' do
    let(:request_data) { Hash['REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/projects',
                              'HTTP_ACCEPT' => 'text/html', 'HTTP_CACHE_CONTROL' => 'max-age=0']}

    it 'yields with request data' do
      expect{|y| subject.request_data(&y) }.to yield_with_args(:get, '/projects', {}, { 'ACCEPT' => 'text/html', 'CACHE_CONTROL' => 'max-age=0' })
    end
  end

  context 'post with body' do
    let(:request_data) { Hash['REQUEST_METHOD' => 'POST', 'PATH_INFO' => '/projects',
                              'HTTP_ACCEPT' => 'text/html', 'HTTP_CACHE_CONTROL' => 'max-age=0',
                              'action_dispatch.request.request_parameters' => request_parameters.to_json
    ]}

    let(:request_parameters) { Hash[test_parameter: 'test_value', second_test_parameter: 'second_test_value'] }

    it 'yields with request data' do
      expect{|y| subject.request_data(&y) }.to yield_with_args(:post, '/projects', request_parameters, { 'ACCEPT' => 'text/html', 'CACHE_CONTROL' => 'max-age=0' })
    end
  end
end