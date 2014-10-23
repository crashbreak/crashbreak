module Crashbreak
  class Configurator
    attr_accessor :api_key
    attr_accessor :exception_notifier

    def exception_notifier
      @exception_notifier || ExceptionNotifier.new
    end
  end
end
