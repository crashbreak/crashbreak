module Crashbreak
  class ExceptionNotifier
    def notify
      RequestStore.store[:server_response] = exceptions_repository.create serialize_exception
      GithubIntegrationService.new(server_response).push_test if Crashbreak.configure.github_repo_name.present? && created_error_is_unique?
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

    def dumpers
      Crashbreak.configure.dumpers
    end

    def serializers
      [BasicInformationFormatter.new] + Crashbreak.configure.error_serializers
    end

    def exceptions_repository
      @exceptions_repository ||= ExceptionsRepository.new
    end

    def created_error_is_unique?
      !server_response['similar']
    end

    def server_response
      RequestStore.store[:server_response]
    end
  end
end
