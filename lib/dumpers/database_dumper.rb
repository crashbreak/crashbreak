require 'digest/md5'

module Crashbreak
  class DatabaseDumper < BasicFormatter
    include Crashbreak::AWS

    def dump
      prepare_aws

      if dump_not_exist_yet?
        dump_database
        upload_dump
        remove_locally_dump
      end

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
      "Crashbreak - database dump #{Digest::MD5.hexdigest(ENV['RACK_ENV'] + exception.class.to_s + exception.backtrace[0])}"
    end

    def dump_not_exist_yet?
      !aws_resource_bucket.object(aws_file_name).exists?
    end

    def dump_location
      Crashbreak.configure.dumper_options[:dump_location]
    end

    def dump_command
      Crashbreak.configure.dumper_options[:dump_command]
    end
  end
end