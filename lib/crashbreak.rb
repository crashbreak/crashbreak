require 'faraday'
require 'request_store'
require 'octokit'
require 'aws-sdk'

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
require 'crashbreak/deploys_repository'
require 'crashbreak/dumpers_data_repository'
require 'crashbreak/request_parser'
require 'crashbreak/github_integration_service'
require 'crashbreak/AWS'
require 'crashbreak/tiny_exception_notifier'
require 'crashbreak/fork_exception_notifier'
require 'crashbreak/predefined_settings'

require 'crashbreak/dumpers/database_dumper'
require 'crashbreak/dumpers/request_dumper'

require 'crashbreak/restorers/database_restorer'
require 'crashbreak/restorers/state_restorer'
require 'crashbreak/restorers/request_restorer'

require 'crashbreak/railtie' if defined?(Rails::Railtie)

module Crashbreak
  extend Configurable

  def self.root
    File.expand_path '../..', __FILE__
  end

  def self.project_root
    self.configurator.project_root
  end
end