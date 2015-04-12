describe Crashbreak::AsyncExceptionNotifier do
  subject { described_class.new }
  let(:request_data) { Oj.dump(Hash[request: 'request_info', current_user: 'current_user_data']) }

  before(:each) do
    expect_any_instance_of(Crashbreak::ExceptionNotifier).to receive(:notify).and_return(true)
  end

  it 'calls notify on exception notifier' do
    subject.perform(request_data)
  end

  it 'sets request_data in RequestStore' do
    expect(RequestStore.store[:request]).to eq('request_info')
    expect(RequestStore.store[:current_user]).to eq('current_user_data')

    subject.perform(request_data)
  end
end