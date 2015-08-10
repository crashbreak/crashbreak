describe 'Sending error report to server' do
  let(:catching_middleware) { Crashbreak::ExceptionCatcherMiddleware.new crashing_app}
  let(:crashing_app) { double(:crashing_app)}

  let(:project_token) { 'example_project_token' }
  let(:example_error) { TestError.new }
  let(:example_request) { double(:example_request, env: { 'PATH_INFO' => 'example_action_name', 'REQUEST_URI' => 'url', 'HTTP_USER_AGENT' => 'agent' } )}
  let(:summary_formatter) { Crashbreak::DefaultSummaryFormatter.new }
  let(:example_controller) { double(:example_controller) }
  let(:env) { Hash['action_controller.instance' => example_controller ]}

  before(:each) do
    Crashbreak.configure.api_key = project_token
    Crashbreak.configure.error_serializers = [summary_formatter, Crashbreak::EnvironmentVariablesFormatter.new, TestErrorFormatter.new]
    Crashbreak.configure.dumpers = [RequestDumper.new]

    allow(crashing_app).to receive(:call).and_raise(example_error)
    allow(example_error).to receive(:backtrace).and_return(%w(example backtrace))
    allow_any_instance_of(Crashbreak::BasicFormatter).to receive(:request).and_return(example_request)
    allow(Crashbreak.configurator).to receive(:ignored_environments).and_return([])
  end

  let!(:create_exception_request) do
    stub_request(:post, "#{Crashbreak::ExceptionsRepository::BASE_URL}/projects/#{project_token}/errors").
        with(body: error_report_hash.to_json).to_return(status: 200, body: { id: 1 }.to_json)
  end

  let(:error_report_hash) do
    {
        name: example_error.to_s, message: example_error.message, backtrace: example_error.backtrace, environment: 'test',
        summary: { action: example_request.env['PATH_INFO'], controller_name: example_controller.class.to_s,
                   file: example_error.backtrace[0], url: example_request.env['REQUEST_URI'], user_agent: example_request.env['HTTP_USER_AGENT'] },
        additional_data: { environment: ENV.to_hash, test: { formatter: true } }
    }
  end

  let!(:update_exception_request) do
    stub_request(:put, "#{Crashbreak::ExceptionsRepository::BASE_URL}/projects/#{project_token}/errors/1").
        with(body: dumpers_data.to_json).to_return(status: 200)
  end

  let(:dumpers_data) { Hash[error_report: { dumpers_data: { 'RequestDumper' => example_request.env } }] }

  it 'sends error report on exception' do
    expect{ catching_middleware.call(env) }.to raise_error(TestError)

    expect(create_exception_request).to have_been_made
    expect(update_exception_request).to have_been_made
  end
end