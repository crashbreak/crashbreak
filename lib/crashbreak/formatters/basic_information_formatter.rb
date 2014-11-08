module Crashbreak
  class BasicInformationFormatter
    def format(exception)
      { name: exception.class.to_s, message: exception.message, backtrace: exception.backtrace, environment: ENV['RACK_ENV'] }
    end
  end
end
