module Crashbreak
  class EnvironmentVariablesFormatter < GroupFormatter
    group_name :environment

    def group_hash
      ENV.to_hash
    end
  end
end
