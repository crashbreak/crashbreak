module Crashbreak
  class Configurator
    attr_accessor :api_key
    attr_accessor :exception_notifier
    attr_accessor :error_serializers

    attr_accessor :github_login
    attr_accessor :github_password
    attr_accessor :github_repo_name
    attr_accessor :github_spec_file_path

    def exception_notifier
      @exception_notifier || ExceptionNotifier.new
    end

    def error_serializers
      @error_serializers || []
    end
  end
end
