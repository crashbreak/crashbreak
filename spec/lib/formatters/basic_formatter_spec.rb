describe Crashbreak::BasicFormatter do
  subject { described_class.new }

  let(:example_request) { double(:request) }
  let(:example_exception) { double(:exception) }

  before(:each) do
    RequestStore.store[:request] = example_request
    RequestStore.store[:exception] = example_exception
  end

  it 'returns request' do
    expect(subject.send(:request)).to eq(example_request)
  end

  it 'returns exception' do
    expect(subject.send(:exception)).to eq(example_exception)
  end
end
