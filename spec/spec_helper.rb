ENV['RACK_ENV'] ||= 'test'

require 'bundler/setup'
require 'webmock/rspec'
Bundler.require :default, :development

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |file| require file }
