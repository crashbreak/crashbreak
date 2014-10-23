describe Crashbreak::ExceptionCatcherMiddleware do
  let(:app_with_crashes) { double(:app_with_crashes)}
  let(:app_without_crashes) { double(:app_without_crashes)}
  let(:error) { StandardError.new }

  before(:each) do
    allow(app_with_crashes).to receive(:call).with(:bad_request).and_raise(error)
    allow(app_without_crashes).to receive(:call).with(:request).and_return(:ok)
  end

  context 'app that raises exception' do
    subject { described_class.new app_with_crashes }

    it 'catches exception' do
      expect_any_instance_of(Crashbreak::ExceptionNotifier).to receive(:notify).with(error)
      expect{ subject.call(:bad_request) }.to raise_error(StandardError)
    end
  end

  context 'app that works without exceptions' do
    subject { described_class.new app_without_crashes }

    it 'does nothing' do
      expect_any_instance_of(Crashbreak::ExceptionNotifier).to_not receive(:notify)
      expect(subject.call(:request)).to eq(:ok)
    end
  end
end
