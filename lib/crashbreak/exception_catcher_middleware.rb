module Crashbreak
  class ExceptionCatcherMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      begin
        @app.call(env)
      rescue ::Exception => exception
        exception_notifier.notify exception
        raise
      end
    end

    private

    def exception_notifier
      Crashbreak.configure.exception_notifier
    end
  end
end
