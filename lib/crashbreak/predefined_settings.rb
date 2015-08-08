module Crashbreak
  class PredefinedSettings
    DEFAULT_DUMP_LOCATION = "#{Rails.root}/tmp/db.dump"

    def postgresql(db_name)
      setup_restorer_for_postgresql

      config.dumper_options.reverse_merge!(
          dump_location: DEFAULT_DUMP_LOCATION,
          dump_command: "pg_dump -Fc #{db_name} > #{DEFAULT_DUMP_LOCATION}"
      )
    end

    def heroku_postgresql(db_name, app_name)
      setup_restorer_for_postgresql

      config.dumper_options.reverse_merge!(
          dump_location: DEFAULT_DUMP_LOCATION,
          dump_command: "/app/vendor/heroku-toolbelt/bin/heroku pg:backups capture #{db_name} -a #{app_name} &&" +
              "curl -o #{DEFAULT_DUMP_LOCATION} `/app/vendor/heroku-toolbelt/bin/heroku pg:backups public-url --app #{app_name}`"
      )
    end

    def mongodb(db_name)
      setup_restorer_for_mongo(db_name)

      config.dumper_options.reverse_merge!(
          dump_location: DEFAULT_DUMP_LOCATION,
          dump_command: "mongodump --db #{db_name} --out #{Rails.root}/tmp/db_dump && tar -cvf #{DEFAULT_DUMP_LOCATION} #{Rails.root}/tmp/db_dump"
      )
    end

    private

    def setup_restorer_for_postgresql
      config.restorer_options.reverse_merge!(
          drop_test_database_command: 'dropdb crashbreak-test',
          create_test_database_command: 'createdb -T template0 crashbreak-test',
          restore_command: "pg_restore -O #{Rails.root}/tmp/db.dump -d crashbreak-test",
          setup_database_connection: -> { ActiveRecord::Base.establish_connection(YAML.load(File.read('config/database.yml'))['crashbreak_test']) }
      )
    end

    def setup_restorer_for_mongo(db_name)
      config.restorer_options.reverse_merge!(
          drop_test_database_command: 'mongo crashbreak-test --eval "db.dropDatabase()"',
          create_test_database_command: '',
          restore_command: "tar -xf #{Rails.root}/tmp/db.dump -C #{Rails.root}/tmp/db_dump && mongorestore --db crashbreak-test #{Rails.root}/tmp/db_dump/#{db_name}",
          setup_database_connection: -> { Mongoid.load!("#{Rails.root}/config/mongoid.yml", :crashbreak_test) }
      )
    end

    def config
      Crashbreak.configurator
    end
  end
end