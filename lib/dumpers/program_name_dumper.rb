class ProgramNameDumper
  def dump
    dump_file.tap do |file|
      file.puts $PROGRAM_NAME
      file.close
    end
  end

  private

  def dump_file
    File.new('program_name.dump', 'w')
  end
end