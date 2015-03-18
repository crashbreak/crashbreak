describe Crashbreak::PGRestorer do
  subject { described_class.new }

  it 'runs pg_restore command' do
    expect(subject).to receive(:exec).exactly(3).times.and_return(true)
    subject.restore
  end
end