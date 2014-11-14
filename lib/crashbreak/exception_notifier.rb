module Crashbreak
  class ExceptionNotifier
    def notify
      exceptions_repository.create serialize_exception
    end

    private

    def serialize_exception
      {}.tap do |exception_hash|
        serializers.each do |serializer|
          exception_hash.deep_merge!(serializer.serialize)
        end
      end
    end

    def serializers
      [BasicInformationFormatter.new] + Crashbreak.configure.error_serializers
    end

    def exceptions_repository
      @exceptions_repository ||= ExceptionsRepository.new
    end
  end
end
