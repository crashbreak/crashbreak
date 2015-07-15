require 'generator_spec'
require_relative '../../../lib/generators/crashbreak/test_generator'

describe Crashbreak::Generators::TestGenerator do
  destination File.expand_path('../../../../tmp', __FILE__)
  arguments %w(example_error_id)

  before(:all) do
    prepare_destination
    run_generator
  end

  it 'creates a test' do
    assert_file Crashbreak.configurator.request_spec_file_path, /example_error_id/
  end
end
