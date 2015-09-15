Crashbreak.configure do |config|
  config.api_key = '<%= token %>'

  # Use Crashbreak::ForkExceptionNotifier if you want to use fork for sending exception data.
  config.exception_notifier = Crashbreak::ExceptionNotifier.new

  # Serialize an exception in the best way for your project, add custom tabs, change default summary.
  config.error_serializers = [Crashbreak::DefaultSummarySerializer.new, Crashbreak::EnvironmentVariablesSerializer.new]

  # Specify dumpers list for future restoring process.
  config.dumpers = [Crashbreak::RequestDumper.new, Crashbreak::DatabaseDumper.new]

  # Config for all dumpers (aws is required for DatabaseDumper)
  config.dumper_options = {
      aws_bucket_name: 'bucket-name-here',
      aws_region: 'us-east-1',      # default: ENV['AWS_REGION']
      aws_access_key_id: 'xxx',     # default: ENV['AWS_ACCESS_KEY_ID']
      aws_secret_access_key: 'xxx', # default: ENV['AWS_SECRET_ACCESS_KEY']
  }

  # Config for GitHub integration
  config.github_integration = false
  config.github_login = ENV['GITHUB_USER']
  config.github_password = ENV['GITHUB_PASSWORD']
  config.github_repo_name = ENV['GITHUB_REPO_NAME']
end
