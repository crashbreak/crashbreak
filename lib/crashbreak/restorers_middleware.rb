module Crashbreak
  class RestorersMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      # It's ugly, we know that...
      env['rack.session'].merge! $session_data if $session_data

      @app.call(env)
    end
  end
end
