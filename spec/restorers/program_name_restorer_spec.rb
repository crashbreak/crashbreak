describe ProgramNameRestorer do
  subject { described_class.new }
  let(:program_name) { 'crashbreak' }

  before(:each) { allow(File).to receive(:readlines).and_return([program_name]) }

  it 'restore global variable $PROGRAM_NAME from file' do
    subject.restore
    expect($PROGRAM_NAME).to eq program_name
  end
end