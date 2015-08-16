require 'fileutils'

module Crashbreak
  class DatabaseDumper < BasicFormatter
    include Crashbreak::AWS

    def dump
      prepare_aws
      make_directories
      dump_database
      upload_dump
      remove_locally_dump

      { file_name: aws_file_name }
    end

    private

    def make_directories
      FileUtils::mkdir_p "#{Rails.root}/tmp/#{error_id}/"
    end

    def dump_database
      system(gsub_error_id(dump_command))
    end

    def upload_dump
      client.put_object(bucket: bucket_name, key: aws_file_name, body: File.read(dump_location))
    end

    def remove_locally_dump
      File.delete(dump_location)
    end

    def aws_file_name
      @aws_file_name ||= "Crashbreak - database dump #{Time.now} (#{Time.now.to_f})"
    end

    def dump_location
      gsub_error_id(Crashbreak.configure.dumper_options[:dump_location])
    end

    def dump_command
      Crashbreak.configure.dumper_options[:dump_command]
    end

    def gsub_error_id(text)
      text.gsub(':error_id:', error_id)
    end

    def error_id
      RequestStore.store[:server_response]['id'].to_s
    end
  end
end