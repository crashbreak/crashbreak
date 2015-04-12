namespace :crashbreak do
  task test: :environment do
    puts 'Testing communication with server...'

    begin
      raise CrashbreakTestError.new('If you see this message everything works fine!')
    rescue CrashbreakTestError => error
      RequestStore.store[:exception] = error
      RequestStore.store[:request] = Rack::Request.new({})

      Crashbreak.configure.exception_notifier.notify
    end

    puts 'Done, now check if error exists on crashbreak.com!'
  end

  task resolve_error: :environment do
    return puts 'error_id must be set (e.g rake crashbreak:resolve_error error_id=123)' if ENV['error_id'].nil?
    service = Crashbreak::GithubIntegrationService.new ENV['error_id']

    puts 'Removing test file from github...'
    service.remove_test

    puts 'Creating pull request'
    service.create_pull_request

    puts 'Resolving error in CrashBreak...'
    Crashbreak::ExceptionsRepository.new.resolve ENV['error_id']
  end
end

class CrashbreakTestError < StandardError
end
