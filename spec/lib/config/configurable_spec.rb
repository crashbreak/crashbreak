describe Crashbreak::Configurable do
  subject do
    module TestModule
      extend Crashbreak::Configurable
    end
  end

  it 'returns configurator object' do
    expect(subject.configure).to be_a_kind_of(Crashbreak::Configurator)
  end

  it 'pass configurator object to block' do
    expect{|block| subject.configure(&block)}.to yield_with_args(Crashbreak::Configurator)
  end

  it 'creates only once configurator instance' do
    expect(subject.configure).to eq subject.configure
  end
end
