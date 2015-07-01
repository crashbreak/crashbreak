module Crashbreak
  class ForkExceptionNotifier
    def notify
      fork do
        exception_notifier.notify
      end
    end

    private

    def exception_notifier
      @exception_notifier ||= ExceptionNotifier.new
    end
  end
end