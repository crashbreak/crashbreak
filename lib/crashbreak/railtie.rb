require 'rails'

module Crashbreak
  class Railtie < ::Rails::Railtie
    initializer 'crashbreak.add_middleware' do
      Rails.application.middleware.use Crashbreak::ExceptionCatcherMiddleware
      Rails.application.middleware.use Crashbreak::RestorersMiddleware if Rails.env.test?
    end

    rake_tasks do
      load 'tasks/crashbreak.rake'
    end
  end
end