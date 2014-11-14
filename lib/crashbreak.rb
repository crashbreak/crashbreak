require 'rails'
require 'faraday'
require 'request_store'
require 'crashbreak/version'
require 'crashbreak/exception_notifier'
require 'crashbreak/formatters/summary_formatter'
require 'crashbreak/formatters/group_formatter'
require 'crashbreak/formatters/basic_information_formatter'
require 'crashbreak/formatters/environment_variables_formatter'
require 'crashbreak/formatters/default_summary_formatter'
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

    rake_tasks do
      load 'tasks/crashbreak.rake'
    end
  end
end
