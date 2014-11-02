module Crashbreak
  class EnvironmentVariablesFormatter
    def format(error)
      { envariament: ENV }
    end
  end
end
