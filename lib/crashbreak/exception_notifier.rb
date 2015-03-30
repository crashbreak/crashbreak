module Crashbreak
  class ExceptionNotifier
    def notify
      error_id = exceptions_repository.create serialize_exception
      GithubIntegrationService.new(error_id).push_test if Crashbreak.configure.github_repo_name.present?
    end

    private

    def serialize_exception
      {}.tap do |exception_hash|
        serializers.each { |serializer| exception_hash.deep_merge!(serializer.serialize) }
        exception_hash[:dumpers_data] = dumpers_data
      end
    end

    def dumpers_data
      dumpers.map do |dumper|
        [dumper.class.to_s, dumper.dump]
      end.to_h
    end

    def dumpers
      [RequestDumper.new]
    end

    def serializers
      [BasicInformationFormatter.new] + Crashbreak.configure.error_serializers
    end

    def exceptions_repository
      @exceptions_repository ||= ExceptionsRepository.new
    end
  end
end
