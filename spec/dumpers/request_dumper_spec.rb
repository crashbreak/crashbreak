describe RequestDumper do
  subject { described_class.new }

  let(:example_request) { double(:request, env: Hash['REQUEST_URI' => 'example_uri']) }

  before(:each) do
    RequestStore.store[:request] = example_request
  end

  it 'returns a request hash' do
    expect(subject.dump).to eq example_request.env
  end

end