module Crashbreak
  class PredefinedSettings
    def postgresql(db_name)
      restorer_for_postgresql

      config.dumper_options.reverse_merge!(
          dump_location: "#{Rails.root}/tmp/db.dump",
          dump_command: "pg_dump -Fc #{db_name} > #{Rails.root}/tmp/db.dump"
      )
    end

    def heroku_postgresql(db_name, app_name)
      restorer_for_postgresql

      config.dumper_options.reverse_merge!(
          dump_location: "#{Rails.root}/tmp/db.dump",
          dump_command: "/app/vendor/heroku-toolbelt/bin/heroku pg:backups capture #{db_name} -a #{app_name} &&" +
              "curl -o #{Rails.root}/tmp/db.dump `/app/vendor/heroku-toolbelt/bin/heroku pg:backups public-url --app #{app_name}`"
      )
    end

    private

    def config
      Crashbreak.configurator
    end

    def restorer_for_postgresql
      config.restorer_options.reverse_merge!(
          drop_test_database_command: 'dropdb crashbreak-test',
          create_test_database_command: 'createdb -T template0 crashbreak-test',
          restore_command: "pg_restore -O #{Rails.root}/tmp/db.dump -d crashbreak-test",
      )
    end
  end
end