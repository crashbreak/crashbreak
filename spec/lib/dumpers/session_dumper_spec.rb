describe Crashbreak::SessionDumper do
  subject { described_class.new }

  let(:example_request) { double(:request, session: fake_session ) }
  let(:fake_session) { double(:session, to_hash: { user_id: 123 }) }

  before(:each) do
    RequestStore.store[:request] = example_request
  end

  it 'returns a request hash' do
    expect(subject.dump).to eq(user_id: 123)
  end

end