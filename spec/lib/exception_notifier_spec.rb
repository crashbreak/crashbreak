describe Crashbreak::ExceptionNotifier do
  subject { described_class.new }
  let(:error) { StandardError.new error_message }
  let(:error_name) { error.class.to_s }
  let(:error_message) { 'example_error_message'}

  before(:each) do
    allow(error).to receive(:backtrace).and_return(%w(example backtrace))
    allow_any_instance_of(Crashbreak::Configurator).to receive(:error_serializers).and_return([])
    allow_any_instance_of(described_class).to receive(:dumpers).and_return([])

    RequestStore[:exception] = error
    RequestStore[:request] = double(:request, env: { request: :example_request_data } )
  end

  let(:exception_basic_hash) do
    { name: error_name, message: error_message, backtrace: error.backtrace, environment: ENV['RACK_ENV'], dumpers_data: {} }
  end

  context 'without additional serializers' do
    it 'sends pure error' do
      expect_any_instance_of(Crashbreak::ExceptionsRepository).to receive(:create).with(exception_basic_hash)
      subject.notify
    end

    context 'with dumpers' do
      let(:expected_hash) { exception_basic_hash.merge(dumpers_hash) }

      let(:dumpers_hash) do
        { dumpers_data: { 'RequestDumper' => { request: 'example_request_data' } } }
      end

      before(:each) do
        allow_any_instance_of(described_class).to receive(:dumpers).and_return([RequestDumper.new])
      end

      it 'sends dump data' do
        expect_any_instance_of(Crashbreak::ExceptionsRepository).to receive(:create).with(expected_hash)
        subject.notify
      end
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
