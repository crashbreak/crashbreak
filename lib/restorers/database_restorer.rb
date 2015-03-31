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
    end

    private

    def restore_database
      system(restore_command)
    end

    def download_dump
      File.open("#{Rails.root}/tmp/db.dump", 'wb') do |file|
        client.get_object(bucket: bucket_name, key: @file_name) do |data|
          file.write(data)
        end
      end
    end

    def restore_command
      Crashbreak.configure.restorer_options[:restore_command]
    end
  end
end
