describe ProgramNameDumper do
  subject { described_class.new }
  let(:file_path) { subject.dump.path }

  it 'file name should be relevant to class' do
    expect(File.basename(file_path)).to eq 'program_name.dump'
  end

  it 'checks file content' do
    expect(File.read(file_path)).to match $PROGRAM_NAME
  end
end