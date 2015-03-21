describe Crashbreak::DumpersDataRepository do
  subject { described_class.new error_id }

  let(:error_id) { 1 }
  let(:project_token) { 'example_project_token' }

  before(:each) do
    Crashbreak.configure.api_key = project_token

    stub_request(:get, "#{described_class::BASE_URL}/projects/#{project_token}/errors/#{error_id}/dumpers_data").
        to_return(status: 200, body: dumpers_data.to_json)
  end

  let(:dumpers_data) { Hash['example_dumpers_data' => 'example'] }

  it 'sends request to create exception report' do
    expect(subject.dumpers_data).to eq dumpers_data
  end
end
