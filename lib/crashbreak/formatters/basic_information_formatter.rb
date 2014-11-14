module Crashbreak
  class BasicInformationFormatter
    def serialize
      { name: exception.class.to_s, message: exception.message, backtrace: exception.backtrace, environment: ENV['RACK_ENV'] }
    end

    private

    def exception
      RequestStore.store[:exception]
    end
  end
end
