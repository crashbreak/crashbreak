module Crashbreak
  class ExceptionNotifier
    def notify
      return if skip_exception?
      response = exceptions_repository.create serialize_exception
      GithubIntegrationService.new(response).push_test if Crashbreak.configure.github_repo_name.present?
    end

    private

    def serialize_exception
      {}.tap do |exception_hash|
        serializers.each { |serializer| exception_hash.deep_merge!(serializer.serialize) }
        exception_hash[:dumpers_data] = dumpers_data
      end
    end

    def dumpers_data
      {}.tap do |dupers_data_hash|
        dumpers.each do |dumper|
          dupers_data_hash[dumper.class.to_s] = dumper.dump
        end
      end
    end

    def skip_exception?
      Crashbreak.configure.ignored_environments.include? ENV['RACK_ENV']
    end

    def dumpers
      Crashbreak.configure.dumpers
    end

    def serializers
      [BasicInformationFormatter.new] + Crashbreak.configure.error_serializers
    end

    def exceptions_repository
      @exceptions_repository ||= ExceptionsRepository.new
    end
  end
end
