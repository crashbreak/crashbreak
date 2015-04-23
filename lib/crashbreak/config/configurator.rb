module Crashbreak
  class Configurator
    attr_accessor :api_key
    attr_accessor :ignored_environments
    attr_accessor :exception_notifier
    attr_accessor :error_serializers
    attr_accessor :dumpers
    attr_accessor :dumper_options
    attr_accessor :restorer_options

    attr_accessor :github_login
    attr_accessor :github_password
    attr_accessor :github_repo_name
    attr_accessor :github_spec_file_path
    attr_accessor :github_development_branch

    def exception_notifier
      @exception_notifier || ExceptionNotifier.new
    end

    def ignored_environments
      @ignored_environments || ['development', 'test']
    end

    def error_serializers
      @error_serializers || []
    end

    def github_spec_file_path
      @github_spec_file_path || 'spec/crashbreak_error_spec.rb'
    end

    def github_development_branch
      @github_development_branch || 'master'
    end

    def dumpers
      @dumpers || []
    end

    def dumper_options
      @dumper_options || {}
    end

    def restorer_options
      @restorer_options || {}
    end
  end
end
