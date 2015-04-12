require 'rails'
require 'faraday'
require 'request_store'
require 'octokit'
require 'aws-sdk'
require 'sidekiq'
require 'oj'

require 'crashbreak/version'
require 'crashbreak/exception_notifier'
require 'crashbreak/formatters/basic_formatter'
require 'crashbreak/formatters/summary_formatter'
require 'crashbreak/formatters/hash_formatter'
require 'crashbreak/formatters/basic_information_formatter'
require 'crashbreak/formatters/environment_variables_formatter'
require 'crashbreak/formatters/default_summary_formatter'
require 'crashbreak/config/configurator'
require 'crashbreak/config/configurable'
require 'crashbreak/exception_catcher_middleware'
require 'crashbreak/exceptions_repository'
require 'crashbreak/dumpers_data_repository'
require 'crashbreak/request_parser'
require 'crashbreak/github_integration_service'
require 'crashbreak/AWS'
require 'crashbreak/async_exception_notifier'

require 'dumpers/database_dumper'
require 'dumpers/request_dumper'

require 'restorers/database_restorer'
require 'restorers/state_restorer'
require 'restorers/request_restorer'

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

  def self.root
    File.expand_path '../..', __FILE__
  end
end
