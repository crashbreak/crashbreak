module Crashbreak
  class Configurator
    attr_accessor :api_key
    attr_accessor :exception_notifier
    attr_accessor :error_serializers

    def exception_notifier
      @exception_notifier || ExceptionNotifier.new
    end

    def error_serializers
      @error_serializers || []
    end
  end
end
