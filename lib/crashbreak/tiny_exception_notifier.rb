module Crashbreak
  class TinyExceptionNotifier < ExceptionNotifier
    def notify(exception = RequestStore.store[:exception])
      RequestStore.store[:exception] = exception
      exceptions_repository.create serialize_exception
    end

    private

    def serializers
      [BasicInformationSerializer.new]
    end

    def dumpers
      []
    end
  end
end
