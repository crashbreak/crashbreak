describe StateRestorer do
  subject { described_class.new error_id }
  let(:error_id) { 1 }
  let(:project_token) { 'example_project_token'}

  before(:each) do
    Crashbreak.configure.api_key = project_token

    stub_request(:get, "#{Crashbreak::DumpersDataRepository::BASE_URL}/projects/#{project_token}/errors/#{error_id}/dumpers_data").
        to_return(status: 200, body: dumpers_data.to_json)
  end

  let(:dumpers_data) { Hash['TestDumper' => { test_key: 'test_data' } ] }

  it 'returns a hash with all restorers data' do
    expect_any_instance_of(TestRestorer).to receive(:initialize)
    expect(subject.restore).to eq(test: 'restored_test_data')
  end

  it 'passes dumper data with error id to restorer' do
    expect_any_instance_of(TestRestorer).to receive(:initialize).with('test_key' => 'test_data', 'error_id' => error_id)
    subject.restore
  end
end

class TestRestorer
  def initialize(data)
    @data = data
  end

  def restore
    'restored_test_data'
  end
end