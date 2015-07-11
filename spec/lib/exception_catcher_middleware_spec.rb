describe Crashbreak::ExceptionCatcherMiddleware do
  let(:app_with_crashes) { double(:app_with_crashes)}
  let(:app_without_crashes) { double(:app_without_crashes)}

  let(:env) { Hash['action_controller.instance' => example_controller ]}
  let(:example_controller) { double(:controller) }
  let(:error) { RegexpError.new }

  before(:each) do
    allow(app_with_crashes).to receive(:call).with(env).and_raise(error)
    allow(app_without_crashes).to receive(:call).with(env).and_return(:ok)
  end

  context 'app that raises exception' do
    subject { described_class.new app_with_crashes }

    before(:each) do
      expect_any_instance_of(Crashbreak::ExceptionNotifier).to receive(:notify).and_return(true)
      expect{ subject.call(env) }.to raise_error(error.class)
    end

    it 'sets exception in store' do
      expect(RequestStore.store[:exception]).to eq(error)
    end

    it 'sets request in store' do
      expect(RequestStore.store[:request]).to be_a_kind_of(Rack::Request)
    end

    it 'sets controller in store' do
      expect(RequestStore.store[:controller]).to eq example_controller
    end
  end

  context 'app that raises exception but current env is ignored' do
    subject { described_class.new app_with_crashes }

    before(:each) do
      expect_any_instance_of(Crashbreak::ExceptionNotifier).to_not receive(:notify)
    end

      it 'skips development environment by default' do
        expect(ENV).to receive(:[]).with('RACK_ENV').and_return('development')
        expect{ subject.call(env) }.to raise_error(error.class)
      end

      it 'skips all environments in config' do
        Crashbreak.configure.ignored_environments = ['staging']

        expect(ENV).to receive(:[]).with('RACK_ENV').and_return('staging')
        expect{ subject.call(env) }.to raise_error(error.class)
      end
  end

  context 'app that works without exceptions' do
    subject { described_class.new app_without_crashes }

    it 'does nothing' do
      expect_any_instance_of(Crashbreak::ExceptionNotifier).to_not receive(:notify)
      expect(subject.call(env)).to eq(:ok)
    end
  end
end
