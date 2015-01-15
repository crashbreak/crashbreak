class ProgramNameRestorer
  def restore
    $PROGRAM_NAME = File.readlines('program_name.dump')[0]
  end
end