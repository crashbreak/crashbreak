module Crashbreak
  class EnvironmentVariablesFormatter
    def format(error)
      { envariament_variables: ENV }
    end
  end
end
