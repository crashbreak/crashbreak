require 'generator_spec'
require_relative '../../../lib/generators/crashbreak/install_generator'

describe Crashbreak::Generators::InstallGenerator do
  destination File.expand_path('../../../../tmp', __FILE__)
  arguments %w(example_project_token)

  before(:all) do
    prepare_destination
    run_generator
  end

  it 'creates an initializer' do
    assert_file 'config/initializers/crashbreak.rb', /example_project_token/
  end
end
