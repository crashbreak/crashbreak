module Crashbreak
  class PredefinedSettings
    def postgresql(db_name)
      config.dumper_options.reverse_merge!(
          dump_location: "#{Rails.root}/tmp/db.dump",
          dump_command: "pg_dump -Fc #{db_name} > #{Rails.root}/tmp/db.dump"
      )

      config.restorer_options.reverse_merge!(
          drop_test_database_command: 'dropdb crashbreak-test',
          create_test_database_command: 'createdb -T template0 crashbreak-test',
          restore_command: "pg_restore #{Rails.root}/tmp/db.dump -d crashbreak-test",
      )
    end

    private

    def config
      Crashbreak.configurator
    end
  end
end