require 'bundler/setup'
Bundler.require :default, :development

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |file| require file }
