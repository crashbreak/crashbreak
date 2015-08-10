describe Crashbreak::ExceptionNotifier do
  subject { described_class.new }
  let(:error) { StandardError.new error_message }
  let(:error_name) { error.class.to_s }
  let(:error_message) { 'example_error_message'}

  before(:each) do
    allow(error).to receive(:backtrace).and_return(%w(example backtrace))
    allow_any_instance_of(Crashbreak::Configurator).to receive(:error_serializers).and_return([])
    allow_any_instance_of(described_class).to receive(:dumpers).and_return([])
    allow_any_instance_of(Crashbreak::GithubIntegrationService).to receive(:push_test).and_return(true)
    allow_any_instance_of(Crashbreak::ExceptionsRepository).to receive(:update).and_return(true)

    RequestStore[:exception] = error
    RequestStore[:request] = double(:request, env: { request: :example_request_data } )
  end

  let(:exception_basic_hash) do
    { name: error_name, message: error_message, backtrace: error.backtrace, environment: ENV['RACK_ENV'] }
  end

  let(:example_response) { Hash['error_id' => 1, 'similar_error' => false] }

  it 'stores server response in request store' do
    expect_any_instance_of(Crashbreak::ExceptionsRepository).to receive(:create).with(exception_basic_hash).and_return(:example_server_response)
    subject.notify

    expect(RequestStore.store[:server_response]).to eq(:example_server_response)
  end

  context 'without additional serializers' do
    it 'sends pure error' do
      expect_any_instance_of(Crashbreak::ExceptionsRepository).to receive(:create).with(exception_basic_hash).and_return(:example_server_response)
      subject.notify
    end

    context 'with dumpers' do
      let(:dumpers_hash) do
        { dumpers_data: { 'RequestDumper' => { request: 'example_request_data' } } }
      end

      before(:each) do
        allow_any_instance_of(described_class).to receive(:dumpers).and_return([RequestDumper.new])
      end

      it 'sends dump data' do
        expect_any_instance_of(Crashbreak::ExceptionsRepository).to receive(:create).and_return('id' => 1, 'similar' => false)
        expect_any_instance_of(Crashbreak::ExceptionsRepository).to receive(:update).with(1, dumpers_hash)

        subject.notify
      end

      it 'skips dump if error is similar' do
        expect_any_instance_of(Crashbreak::ExceptionsRepository).to receive(:create).and_return('id' => 1, 'similar' => true)
        expect_any_instance_of(Crashbreak::ExceptionsRepository).to_not receive(:update).with(1, dumpers_hash)

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
        expect_any_instance_of(Crashbreak::ExceptionsRepository).to receive(:create).with(expected_hash).and_return(example_response)
        subject.notify
      end
    end

    context 'github integration' do
      let(:error_hash) { Hash['id' => 1, 'deploy_revision' => 'test', 'similar' => false] }

      it 'passes error hash from request to github integration service' do
        Crashbreak.configure.github_repo_name = 'user/repo'

        allow_any_instance_of(Crashbreak::ExceptionsRepository).to receive(:create).and_return(error_hash)
        expect_any_instance_of(Crashbreak::GithubIntegrationService).to receive(:initialize).with(error_hash)

        subject.notify
      end

      it 'skips github integration if error is similar' do
        allow_any_instance_of(Crashbreak::ExceptionsRepository).to receive(:create).and_return(error_hash.merge('similar' => true))
        expect_any_instance_of(Crashbreak::GithubIntegrationService).to_not receive(:initialize)

        subject.notify
      end
    end
  end
end
