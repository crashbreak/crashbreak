module Crashbreak
  class ExceptionNotifier
    def notify(exception)
      exceptions_repository.create format_exception(exception)
    end

    private

    def format_exception(exception)
      basic_information(exception).merge format(exception)
    end

    def format(exception)
      {}.tap do |exception_hash|
        formatters.each do |formatter|
          exception_hash.merge!(formatter.format exception)
        end
      end
    end

    def basic_information(exception)
      { name: exception.to_s, message: exception.message}
    end

    def formatters
      Crashbreak.configure.error_formatters
    end

    def exceptions_repository
      @exceptions_repository ||= ExceptionsRepository.new
    end
  end
end
