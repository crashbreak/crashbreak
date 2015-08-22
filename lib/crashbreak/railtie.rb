require 'rails'

module Crashbreak
  class Railtie < ::Rails::Railtie
    initializer 'crashbreak.add_middleware' do
      Rails.application.middleware.use Crashbreak::ExceptionCatcherMiddleware
    end

    rake_tasks do
      load 'tasks/crashbreak.rake'
    end
  end
end