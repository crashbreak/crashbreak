module Crashbreak
  class ExceptionCatcherMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      begin
        @app.call(env)
      rescue ::Exception => exception
        RequestStore.store[:exception] = exception
        RequestStore.store[:request] = request(env)
        exception_notifier.notify
        raise
      end
    end

    private

    def exception_notifier
      Crashbreak.configure.exception_notifier
    end

    def request(env)
      Rack::Request.new(env)
    end
  end
end
