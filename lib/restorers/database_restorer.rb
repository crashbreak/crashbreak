require 'fileutils'

module Crashbreak
  class DatabaseRestorer
    include AWS

    def initialize(dump_data)
      @error_id = dump_data['error_id']
      @file_name = dump_data['file_name']
    end

    def restore
      system(drop_test_database_command)
      system(create_test_database_command)
      prepare_aws
      make_directories
      download_dump
      restore_database
      setup_connection_to_restored_database
    end

    private

    def make_directories
      FileUtils::mkdir_p "#{Rails.root}/tmp/#{@error_id}/"
    end

    def restore_database
      system(restore_command)
    end

    def download_dump
      Dir.mkdir("#{Rails.root}/tmp/") unless File.exists?("#{Rails.root}/tmp/")

      File.open(restore_location, 'wb') do |file|
        client.get_object(bucket: bucket_name, key: @file_name) do |data|
          file.write(data)
        end
      end
    end

    def setup_connection_to_restored_database
      Crashbreak.configure.restorer_options[:setup_database_connection].call
    end

    def restore_command
      gsub_error_id(Crashbreak.configure.restorer_options[:restore_command])
    end

    def drop_test_database_command
      Crashbreak.configure.restorer_options[:drop_test_database_command]
    end

    def create_test_database_command
      Crashbreak.configure.restorer_options[:create_test_database_command]
    end

    def restore_location
      gsub_error_id(Crashbreak.configure.dumper_options[:dump_location])
    end

    def gsub_error_id(text)
      text.gsub(':error_id:', @error_id)
    end
  end
end
