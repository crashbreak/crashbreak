describe Crashbreak::PGDumper do
  subject { described_class.new }

  it 'runs pg_dump command' do
    expect(subject).to receive(:exec).and_return(true)
    subject.dump
  end
end