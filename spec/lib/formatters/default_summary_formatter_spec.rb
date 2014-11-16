describe Crashbreak::DefaultSummaryFormatter do
  subject { described_class.new }

  let(:example_request) { double(:request, action: example_action_name) }
  let(:example_action_name) { 'controller#action' }
  let(:example_controller) { double(:controller) }

  before(:each) do
    RequestStore.store[:request] = example_request
    RequestStore.store[:controller] = example_controller
  end

  it 'formats default summary' do
    expect(subject.summary).to eq(action: example_request.action, controller_name: example_controller.class.to_s)
  end
end
