module Crashbreak
  class ExceptionNotifier
    def notify
      RequestStore.store[:server_response] = exceptions_repository.create serialize_exception

      if created_error_is_unique?
        dump_system_and_update_report

        GithubIntegrationService.new(server_response).push_test if Crashbreak.configure.github_repo_name.present?
      end
    end

    private

    def dump_system_and_update_report
      exceptions_repository.update server_response['id'], dumpers_data: dumpers_data
    end

    def serialize_exception
      {}.tap do |exception_hash|
        serializers.each { |serializer| exception_hash.deep_merge!(serializer.serialize) }
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
