module Crashbreak
  class PredefinedSettings
    class << self
      def dump_file_location
        "#{Rails.root}/tmp/:error_id:/db.dump"
      end

      def dump_folder_location
        "#{Rails.root}/tmp/:error_id:/db_dump"
      end

      def postgresql(db_name)
        setup_restorer_for_postgresql

        config.dumper_options.reverse_merge!(
            dump_location: dump_file_location,
            dump_command: "pg_dump -Fc #{db_name} > #{dump_file_location}"
        )
      end

      def heroku_postgresql(db_name, app_name)
        setup_restorer_for_postgresql

        config.dumper_options.reverse_merge!(
            dump_location: dump_file_location,
            dump_command: "/app/vendor/heroku-toolbelt/bin/heroku pg:backups capture #{db_name} -a #{app_name} &&" +
                "curl -o #{dump_file_location} `/app/vendor/heroku-toolbelt/bin/heroku pg:backups public-url --app #{app_name}`"
        )
      end

      def mongodb(db_name)
        setup_restorer_for_mongo(db_name)

        config.dumper_options.reverse_merge!(
            dump_location: dump_file_location,
            dump_command: "mongodump --db #{db_name} --out #{dump_folder_location} &&
                           tar -cvf #{dump_file_location} -C #{dump_folder_location} . &&
                           rm -rf #{dump_folder_location}"
        )
      end

      private

      def setup_restorer_for_postgresql
        config.restorer_options.reverse_merge!(
            drop_test_database_command: 'dropdb crashbreak-test',
            create_test_database_command: 'createdb -T template0 crashbreak-test',
            restore_command: "pg_restore -O #{dump_file_location} -d crashbreak-test",
            setup_database_connection: -> { ActiveRecord::Base.establish_connection(YAML.load(File.read("#{Rails.root}/config/database.yml"))['crashbreak_test']) }
        )
      end

      def setup_restorer_for_mongo(db_name)
        config.restorer_options.reverse_merge!(
            drop_test_database_command: 'mongo crashbreak-test --eval "db.dropDatabase()"',
            create_test_database_command: '',
            restore_command: "mkdir -p #{dump_folder_location} &&
                              tar -xf #{dump_file_location} -C #{dump_folder_location} &&
                              mongorestore --db crashbreak-test #{dump_folder_location}/#{db_name}",
            setup_database_connection: -> { Mongoid.load!("#{Rails.root}/config/mongoid.yml", :crashbreak_test) }
        )
      end

      def config
        Crashbreak.configurator
      end
    end
  end
end