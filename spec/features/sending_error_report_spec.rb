describe 'Sending error report to server' do
  let(:catching_middleware) { Crashbreak::ExceptionCatcherMiddleware.new crashing_app}
  let(:crashing_app) { double(:crashing_app)}

  let(:project_token) { 'example_project_token' }
  let(:example_error) { StandardError.new }
  let(:example_request) { double(:example_request, action: 'example_action_name' )}

  before(:each) do
    Crashbreak.configure.api_key = project_token
    Crashbreak.configure.error_formatters = [Crashbreak::SummaryFormatter.new, Crashbreak::EnvironmentVariablesFormatter.new, TestErrorFormatter.new]

    allow(crashing_app).to receive(:call).and_raise(example_error)
    allow(example_error).to receive(:backtrace).and_return(%w(example backtrace))
  end

  let!(:create_exception_request) do
    stub_request(:post, "#{Crashbreak::ExceptionsRepository::BASE_URL}/projects/#{project_token}/exceptions").
        with(body: error_report_hash.to_json).to_return(status: 200)
  end

  let(:error_report_hash) do
    {
        name: example_error.to_s, message: example_error.message, backtrace: example_error.backtrace, envariament: 'test',
        summary: { action: example_request.action }, envariament_variables: ENV, test: :formatter
    }
  end

  it 'sends error report on exception' do
    expect{ catching_middleware.call(:env) }.to raise_error(StandardError)
    expect(create_exception_request).to have_been_made
  end
end
