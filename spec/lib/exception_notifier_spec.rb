describe Crashbreak::ExceptionNotifier do
  subject { described_class.new }
  let(:error) { StandardError.new error_message }
  let(:error_name) { error.to_s }
  let(:error_message) { 'example_error_message'}

  context 'without decorators' do
    let(:expected_basic_hash) do
      { name: error_name, message: error_message }
    end

    it 'sends pure error' do
      expect_any_instance_of(Crashbreak::ExceptionsRepository).to receive(:create).with(expected_basic_hash)
      subject.notify error
    end
  end

  context 'with decorators' do
    let(:expected_decorated_hash) { basic_hash.merge(decorator_hash) }

    let(:basic_hash) do
      { name: error_name, message: error_message }
    end

    let(:decorator_hash) do
      { additional_decorated_key: :example, additional_decorated_data: { looks_good: :yes } }
    end

    let(:decorator) { double(:decorator) }

    before(:each) do
      allow(decorator).to receive(:format).with(error).and_return(decorator_hash)
      allow(subject).to receive(:formatters).and_return([decorator])
    end

    it 'sends decorated error' do
      expect_any_instance_of(Crashbreak::ExceptionsRepository).to receive(:create).with(expected_decorated_hash)
      subject.notify error
    end
  end
end
