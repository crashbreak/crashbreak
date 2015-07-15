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
    error_id = ENV['error_id']

    unless error_id
      next unless File.exist?("#{Rails.root}/#{Crashbreak.configurator.request_spec_file_path}")
      error_id = File.read("#{Rails.root}/#{Crashbreak.configurator.request_spec_file_path}").scan(/error id: \d+/).first.gsub('error id: ', '').to_i
    end

    service = Crashbreak::GithubIntegrationService.new 'id' => error_id

    puts 'Removing test file from github...'
    service.remove_test

    puts 'Creating pull request'
    service.create_pull_request

    puts 'Resolving error in CrashBreak...'
    Crashbreak::ExceptionsRepository.new.resolve error_id
  end

  task run_test: :environment do
    unless File.exist?("#{Rails.root}/#{Crashbreak.configurator.request_spec_file_path}")
      next puts 'Crashbreak spec not found, skipping.'
    end

    system("bundle exec rspec #{Crashbreak.configurator.request_spec_file_path}") or raise 'Crashbreak test failed.'
  end
end

class CrashbreakTestError < StandardError
end
