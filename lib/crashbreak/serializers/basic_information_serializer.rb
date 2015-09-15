module Crashbreak
  class BasicInformationSerializer < BasicSerializer
    def serialize
      { name: exception.class.to_s, message: exception.message, backtrace: exception.backtrace, environment: ENV['RACK_ENV'] }
    end
  end
end
