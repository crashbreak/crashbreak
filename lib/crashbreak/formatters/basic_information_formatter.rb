module Crashbreak
  class BasicInformationFormatter
    def format(exception)
      { name: exception.to_s, message: exception.message, backtrace: exception.backtrace, envariament: ENV['RACK_ENV'] }
    end
  end
end
