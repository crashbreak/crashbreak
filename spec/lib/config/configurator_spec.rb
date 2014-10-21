describe Crashbreak::Configurator do
  subject { described_class.new }

  let(:example_api_key) { 'example_api_key' }

  it 'sets api key' do
    expect do
      subject.api_key = example_api_key
    end.to change{ subject.api_key }.from(nil).to(example_api_key)
  end
end
