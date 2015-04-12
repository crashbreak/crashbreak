module Crashbreak
  class AsyncExceptionNotifier
    include Sidekiq::Worker

    def perform(request_store_data)
      RequestStore.store.merge!(Oj.load(request_store_data))
      exception_notifier.notify
    end

    private

    def exception_notifier
      @exception_notifier ||= ExceptionNotifier.new
    end
  end
end