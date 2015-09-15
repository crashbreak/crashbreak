module Crashbreak
  class EnvironmentVariablesSerializer < HashSerializer
    hash_name :environment

    def hash_value
      ENV.to_hash
    end
  end
end
