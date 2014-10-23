require 'rails'
require 'crashbreak/version'
require 'crashbreak/exception_notifier'
require 'crashbreak/config/configurator'
require 'crashbreak/config/configurable'
require 'crashbreak/exception_catcher_middleware'

module Crashbreak
  extend Configurable

  class Railtie < ::Rails::Railtie
    initializer 'crashbreak.add_middleware' do
      Rails.application.middleware.use Crashbreak::ExceptionCatcherMiddleware
    end
  end
end
