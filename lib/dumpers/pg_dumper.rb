class Crashbreak::PGDumper
  def dump
    exec("pg_dump -Fc crashbreak-development > #{Rails.root}tmp/db.dump")
  end
end