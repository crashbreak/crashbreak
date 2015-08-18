module Crashbreak
  module Generators
    class TestGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)
      argument :error_id, type: :string

      def create_test_file
        template Crashbreak.configurator.request_spec_template_path, Crashbreak.configurator.request_spec_file_path
      end
    end
  end
end
