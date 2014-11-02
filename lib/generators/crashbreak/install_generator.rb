module Crashbreak
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)
      argument :token, type: :string

      def create_initializer_file
        template 'crashbreak.rb', 'config/initializers/crashbreak.rb'
      end
    end
  end
end
