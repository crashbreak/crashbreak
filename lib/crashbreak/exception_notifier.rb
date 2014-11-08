module Crashbreak
  class ExceptionNotifier
    def notify(exception)
      exceptions_repository.create format_exception(exception)
    end

    private

    def format_exception(exception)
      {}.tap do |exception_hash|
        formatters.each do |formatter|
          exception_hash.deep_merge!(formatter.format exception)
        end
      end
    end

    def formatters
      [BasicInformationFormatter.new] + Crashbreak.configure.error_formatters
    end

    def exceptions_repository
      @exceptions_repository ||= ExceptionsRepository.new
    end
  end
end
