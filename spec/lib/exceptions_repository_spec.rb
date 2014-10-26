describe Crashbreak::ExceptionsRepository do
  subject { described_class.new }

  let(:project_token) { 'example_project_token' }

  before(:each) do
    Crashbreak.configure.api_key = project_token
  end

  let(:error_report_hash) do
    { name: 'Example name', message: 'Example message', backtrace: [%w(example backtrace)], additional_hash: { example: :true }}
  end

  let!(:create_exception_request) do
    stub_request(:post, "#{described_class::BASE_URL}/projects/#{project_token}/exceptions").
        with(body: error_report_hash.to_json).to_return(status: 200)
  end

  it 'sends request to create exception report' do
    subject.create error_report_hash
    expect(create_exception_request).to have_been_made
  end
end
