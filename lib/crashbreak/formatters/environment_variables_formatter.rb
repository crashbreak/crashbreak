module Crashbreak
  class EnvironmentVariablesFormatter
    def format(error)
      { additional_data: { environment: ENV.to_hash } }
    end
  end
end
