module Crashbreak
  class PGRestorer
    def restore
      exec('dropdb crashbreak-test-db')
      exec('createdb -T template0 crashbreak-test-db')
      exec("pg_restore #{Rails.root}tmp/db.dump -d crashbreak-test-db")
    end
  end
end