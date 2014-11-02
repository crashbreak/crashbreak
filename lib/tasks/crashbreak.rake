namespace :crashbreak do
  task test: :environment do
    puts 'Testing communication with server...'

    begin
      raise CrashbreakTestError.new('If you see this message everything works fine!')
    rescue CrashbreakTestError => error
      Crashbreak.configure.exception_notifier.notify error
    end

    puts 'Done, now check if error exists on crashbreak.com!'
  end
end

class CrashbreakTestError < StandardError
end
