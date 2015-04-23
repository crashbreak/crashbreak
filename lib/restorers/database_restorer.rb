module Crashbreak
  class DatabaseRestorer
    include AWS

    def initialize(dump_data)
      @file_name = dump_data['file_name']
    end

    def restore
      system('dropdb crashbreak-test')
      system('createdb -T template0 crashbreak-test')
      prepare_aws
      download_dump
      restore_database
      setup_connection_to_restored_database
    end

    private

    def restore_database
      system(restore_command)
    end

    def download_dump
      Dir.mkdir("#{Rails.root}/tmp/") unless File.exists?("#{Rails.root}/tmp/")

      File.open("#{Rails.root}/tmp/db.dump", 'wb') do |file|
        client.get_object(bucket: bucket_name, key: @file_name) do |data|
          file.write(data)
        end
      end
    end

    def restore_command
      Crashbreak.configure.restorer_options[:restore_command]
    end

    def setup_connection_to_restored_database
      if Crashbreak.configure.restorer_options[:setup_database_connection].present?
        Crashbreak.configure.restorer_options[:setup_database_connection].call
      else
        ActiveRecord::Base.establish_connection(database_config.merge(database: 'crashbreak-test')) if database_config
      end
    end

    def database_config
      @database_config ||= YAML.load(File.read('config/database.yml')).try(:[], 'test')
    end
  end
end
