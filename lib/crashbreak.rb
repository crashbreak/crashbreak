require 'faraday'
require 'request_store'
require 'octokit'
require 'aws-sdk'

require 'crashbreak/version'
require 'crashbreak/exception_notifier'
require 'crashbreak/exception_catcher_middleware'
require 'crashbreak/request_parser'
require 'crashbreak/github_integration_service'
require 'crashbreak/AWS'
require 'crashbreak/tiny_exception_notifier'
require 'crashbreak/fork_exception_notifier'
require 'crashbreak/predefined_settings'

require 'crashbreak/serializers/basic_serializer'
require 'crashbreak/serializers/summary_serializer'
require 'crashbreak/serializers/hash_serializer'
require 'crashbreak/serializers/basic_information_serializer'
require 'crashbreak/serializers/environment_variables_serializer'
require 'crashbreak/serializers/default_summary_serializer'

require 'crashbreak/config/configurator'
require 'crashbreak/config/configurable'

require 'crashbreak/repositories/base_repository'
require 'crashbreak/repositories/exceptions_repository'
require 'crashbreak/repositories/deploys_repository'
require 'crashbreak/repositories/dumpers_data_repository'

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