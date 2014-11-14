describe Crashbreak::ExceptionNotifier do
  subject { described_class.new }
  let(:error) { StandardError.new error_message }
  let(:error_name) { error.class.to_s }
  let(:error_message) { 'example_error_message'}

  before(:each) do
    allow(error).to receive(:backtrace).and_return(%w(example backtrace))
    RequestStore[:exception] = error
  end

  let(:exception_basic_hash) do
    { name: error_name, message: error_message, backtrace: error.backtrace, environment: ENV['RACK_ENV'] }
  end

  context 'without additional serializers' do
    before(:each) { allow_any_instance_of(Crashbreak::Configurator).to receive(:error_serializers).and_return([]) }
    it 'sends pure error' do
      expect_any_instance_of(Crashbreak::ExceptionsRepository).to receive(:create).with(exception_basic_hash)
      subject.notify
    end
  end

  context 'with additional serializers' do
    let(:expected_hash) { exception_basic_hash.merge(serializer_hash) }

    let(:serializer_hash) do
      { additional_key: :example, additional_data: { looks_good: :yes } }
    end

    let(:serializer) { double(:serializer) }

    before(:each) do
      allow(serializer).to receive(:serialize).and_return(serializer_hash)
      allow_any_instance_of(Crashbreak::Configurator).to receive(:error_serializers).and_return([serializer])
    end

    it 'sends formatted error' do
      expect_any_instance_of(Crashbreak::ExceptionsRepository).to receive(:create).with(expected_hash)
      subject.notify
    end
  end
end
