module Crashbreak
  class ExceptionCatcherMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      begin
        @app.call(env)
      rescue ::Exception => exception
        unless skip_exception?(exception)
          RequestStore.store[:exception] = exception
          store_variables_from_env env
          exception_notifier.notify
        end

        raise
      end
    end

    private

    def exception_notifier
      Crashbreak.configure.exception_notifier
    end

    def store_variables_from_env(env)
      RequestStore.store[:request] = request(env)
      RequestStore.store[:controller] = env['action_controller.instance']
    end

    def request(env)
      Rack::Request.new(env)
    end

    def skip_exception?(exception)
      Crashbreak.configure.ignored_environments.include?(ENV['RACK_ENV'] || ENV['RAILS_ENV']) ||
      Crashbreak.configure.ignored_exceptions.include?(exception.class)
    end
  end
end
