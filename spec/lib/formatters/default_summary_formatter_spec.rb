describe Crashbreak::DefaultSummaryFormatter do
  subject { described_class.new }

  let(:example_request) { double(:request, env: request_env) }
  let(:request_env) { Hash['PATH_INFO' => 'example_path', 'REQUEST_URI' => 'example_uri', 'HTTP_USER_AGENT' => 'firefox']}
  let(:example_controller) { double(:controller) }
  let(:example_exception) { double(:exception, backtrace: ['file.rb#12'])}

  before(:each) do
    RequestStore.store[:request] = example_request
    RequestStore.store[:controller] = example_controller
    RequestStore.store[:exception] = example_exception
  end

  it 'formats default summary' do
    expect(subject.summary).to eq(action: example_request.env['PATH_INFO'],
                                  controller_name: example_controller.class.to_s,
                                  file: example_exception.backtrace[0],
                                  url: example_request.env['REQUEST_URI'],
                                  user_agent: example_request.env['HTTP_USER_AGENT'])
  end
end
