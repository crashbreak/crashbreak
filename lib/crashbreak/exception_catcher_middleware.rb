module Crashbreak
  class ExceptionCatcherMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      begin
        @app.call(env)
      rescue ::Exception => exception
        unless skip_exception?
          RequestStore.store[:exception] = exception
          store_variables_from_env env
          notify_about_exception
        end

        raise
      end
    end

    private

    def notify_about_exception
      if exception_notifier.respond_to?(:perform_async)
        prepare_request_store_for_serialization
        exception_notifier.perform_async Oj.dump(RequestStore.store)
      else
        exception_notifier.notify
      end
    end

    def prepare_request_store_for_serialization
      request_hash = {}

      RequestStore.store[:request].env.each do |key, value|
        request_hash[key] = value.to_s
      end

      RequestStore.store[:request] = request(request_hash)

      controller = RequestStore.store[:controller].dup

      [:@_env, :@_request, :@_response, :@_lookup_context].each do |variable_symbol|
        controller.instance_variable_set(variable_symbol, nil)
      end

      RequestStore.store[:controller] = controller
    end

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

    def skip_exception?
      Crashbreak.configure.ignored_environments.include?(ENV['RACK_ENV'] || ENV['RAILS_ENV'])
    end
  end
end
