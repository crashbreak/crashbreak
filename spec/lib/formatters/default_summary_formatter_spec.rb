describe Crashbreak::DefaultSummaryFormatter do
  subject { described_class.new }

  let(:example_request) { double(:request, action: example_action_name) }
  let(:example_action_name) { 'controller#action' }

  before(:each) do
    RequestStore.store[:request] = example_request
  end

  it 'formats default summary' do
    expect(subject.summary).to eq(action: example_request.action)
  end
end
