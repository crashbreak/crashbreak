describe Crashbreak::ExceptionsRepository do
  subject { described_class.new }

  let(:project_token) { 'example_project_token' }
  let(:exception_id) { 1 }
  let(:current_deploy_revision) { 'current_deploy_revision' }

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
        with(body: error_report_hash.to_json).to_return(status: 200, body: { id: exception_id, deploy_revision: current_deploy_revision }.to_json)
  end

  let!(:resolve_exception_request) do
    stub_request(:put, "#{described_class::BASE_URL}/projects/#{project_token}/errors/#{exception_id}").
        with(body: { error_report: { status: :resolved } }.to_json)
  end

  it 'sends request to create exception report' do
    expect(subject.create error_report_hash).to eq('id' => exception_id, 'deploy_revision' => current_deploy_revision)
    expect(create_exception_request).to have_been_made
  end

  it 'resolves error' do
    subject.resolve exception_id
  end
end
