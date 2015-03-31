module Crashbreak
  class DatabaseDumper
    include Crashbreak::AWS

    def dump
      dump_database
      prepare_aws
      upload_dump
      remove_locally_dump
      { file_name: aws_file_name }
    end

    private

    def dump_database
      system(dump_command)
    end

    def upload_dump
      client.put_object(bucket: bucket_name, key: aws_file_name, body: File.read(dump_location))
    end

    def remove_locally_dump
      File.delete(dump_location)
    end

    def aws_file_name
      @aws_file_name ||= "Crashbreak - database dump #{DateTime.now.utc}"
    end

    def dump_location
      Crashbreak.configure.dumper_options[:dump_location]
    end

    def dump_command
      Crashbreak.configure.dumper_options[:dump_command]
    end
  end
end