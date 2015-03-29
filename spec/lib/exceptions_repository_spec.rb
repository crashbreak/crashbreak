describe Crashbreak::ExceptionsRepository do
  subject { described_class.new }

  let(:project_token) { 'example_project_token' }
  let(:exception_id) { 1 }

  before(:each) do
    Crashbreak.configure.api_key = project_token
  end

  let(:error_report_hash) do
    {
        name: 'Example name', message: 'Example message', backtrace: [%w(example backtrace)],
        additional_data: { additional_hash: { example: :true }, second: { test: 'true' } }
    }
  end

  let!(:create_exception_request) do
    stub_request(:post, "#{described_class::BASE_URL}/projects/#{project_token}/errors").
        with(body: error_report_hash.to_json).to_return(status: 200, body: { id: exception_id }.to_json)
  end

  it 'sends request to create exception report' do
    expect(subject.create error_report_hash).to eq exception_id
    expect(create_exception_request).to have_been_made
  end
end
