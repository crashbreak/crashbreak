require 'rails'
require 'crashbreak/version'
require 'crashbreak/exception_notifier'
require 'crashbreak/formatters/basic_information_formatter'
require 'crashbreak/formatters/environment_variables_formatter'
require 'crashbreak/config/configurator'
require 'crashbreak/config/configurable'
require 'crashbreak/exception_catcher_middleware'
require 'crashbreak/exceptions_repository'

module Crashbreak
  extend Configurable

  class Railtie < ::Rails::Railtie
    initializer 'crashbreak.add_middleware' do
      Rails.application.middleware.use Crashbreak::ExceptionCatcherMiddleware
    end
  end
end
