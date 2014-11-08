describe Crashbreak::ExceptionNotifier do
  subject { described_class.new }
  let(:error) { StandardError.new error_message }
  let(:error_name) { error.class.to_s }
  let(:error_message) { 'example_error_message'}

  before(:each) { allow(error).to receive(:backtrace).and_return(%w(example backtrace)) }

  let(:exception_basic_hash) do
    { name: error_name, message: error_message, backtrace: error.backtrace, environment: ENV['RACK_ENV'] }
  end

  context 'without formatters' do
    before(:each) { allow_any_instance_of(Crashbreak::Configurator).to receive(:error_formatters).and_return([]) }
    it 'sends pure error' do
      expect_any_instance_of(Crashbreak::ExceptionsRepository).to receive(:create).with(exception_basic_hash)
      subject.notify error
    end
  end

  context 'with formatters' do
    let(:expected_formatted_hash) { exception_basic_hash.merge(formatter_hash) }

    let(:formatter_hash) do
      { additional_key: :example, additional_data: { looks_good: :yes } }
    end

    let(:formatter) { double(:formatter) }

    before(:each) do
      allow(formatter).to receive(:format).with(error).and_return(formatter_hash)
      allow_any_instance_of(Crashbreak::Configurator).to receive(:error_formatters).and_return([formatter])
    end

    it 'sends formatted error' do
      expect_any_instance_of(Crashbreak::ExceptionsRepository).to receive(:create).with(expected_formatted_hash)
      subject.notify error
    end
  end
end
