module Crashbreak
  module Generators
    class TestGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)
      argument :error_id, type: :string

      def create_test_file
        template 'test.rb', 'spec/error_request_spec.rb'
      end
    end
  end
end
