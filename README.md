# Crashbreak [![Version](http://img.shields.io/gem/v/crashbreak.svg)                               ](https://rubygems.org/gems/crashbreak) [![Build Status](https://travis-ci.org/crashbreak/crashbreak.svg?branch=master)](https://travis-ci.org/crashbreak/crashbreak) [![Code Climate](https://codeclimate.com/github/crashbreak/crashbreak/badges/gpa.svg)](https://codeclimate.com/github/crashbreak/crashbreak)

Crashbreak gem is a exception notifier for integration with [crashbreak.com](http://crashbreak.com) for ruby apllications.

## Rails Installation

Add this line to your application's Gemfile:

    gem 'crashbreak'

And then execute from your rails root:

    $ bundle

Generate crashbreak initializer:

    rails generate crashbreak:install your_api_key

If you want to use database dumper add this lines to datbase.yml file:

    crashbreak_test:
      <<: *default
      database: crashbreak-test

## Example crashbreak.rb (initializer)
[Rails example](https://github.com/crashbreak/heroku-rails-example/blob/master/config/initializers/crashbreak.rb)

[Grape example](https://github.com/crashbreak/grape_example/blob/master/crashbreak.rb)

## Initializer options

### Error Serializers
Each serializer converts an exception to JSON request, by customizing this you can create your own exception page in crashbreak.com. There are two types of serializers - summary serializer and hash serializer. 

#### Summary serializer
Summary serializer specify the first tab on exception show view and data included in email. This is an example of default summary formatter:

```ruby
class DefaultSummaryFormatter < SummaryFormatter
  def summary
    {
      action: request.env['PATH_INFO'],
      controller_name: controller.class.to_s,
      file: exception.backtrace[0],
      url: request.env['REQUEST_URI'],
      user_agent: request.env['HTTP_USER_AGENT']
    }
  end
end
```

#### Hash serializer
By using hash serializer you can serialize your custom data into hash and display it in new tab on our web page. For example this is a ```EnvironmentVariablesSerializer```:

```ruby
class EnvironmentVariablesFormatter < HashFormatter
  hash_name :environment

  def hash_value
    ENV.to_hash
  end
end
```
It adds new tab called "Environment" with all ENV variables displayed in "key: value" format.

### Dumpers (and restorers)
Dumpers are responsible for dump your system and prepare for restore by simulate request test. There are two very important dumpers - request dumper and database dumper. Each dumper is connected to specify restorer (eg ```RequestDumper``` to ```RequestRestorer```) to dump some part of system and restore it in crashbreak test env. This is a part of database dumper:

```ruby
# Crashbreak::DatabaseDumper
def dump
  prepare_aws # you need your custom aws bucket
  dump_database
  upload_dump
  remove_locally_dump
    
  { file_name: aws_file_name } # only this hash is stored by crashbreak
end

# Crashbreak::DatabaseRestorer
def restore
  recreate_test_database
  prepare_aws
  download_dump unless dump_already_downloaded
  restore_database
  setup_connection_to_restored_database
end
```

### Predefined settings
Dumping your database or any other part of the system requires config for dumpers, for example DatabaseDumper needs a command for dump db (e.g pg_dump for postgresql). There is a file with all predefined settings that you can use if you have standard setup. Please check [this file](https://github.com/crashbreak/crashbreak/blob/master/lib/crashbreak/predefined_settings.rb). For be sure that all commands run corretcly on your staging server please run it manually first and see the result.

### Exception notifier
Dumping your system can take some time, in order to improve request response you can use different exception notifier.

```ruby
config.exception_notifier = Crashbreak::ExceptionNotifier.new      # default notifier (one thread)
config.exception_notifier = Crashbreak::ForkExceptionNotifier.new  # creates fork
```

## Integrations

### Github
Crashbreak can automaticaly creates branch with failing request for exception that occurs on your staging / production server. Your part of the job is just pull, run the test and fix the bug!
```ruby
config.github_login = ENV['GITHUB_USER']
config.github_password = ENV['GITHUB_PASSWORD']
config.github_repo_name = 'crashbreak/heroku-rails-example'
```

### CI sever
With CI server you can automatically test your fix on external server. If tests succeed just run crashbreak rake task to resolve the error in our system. If you are using the github integration, the rake task can also create a pull request from branch with error to master.
```ruby
after_success:
  - bundle exec rake crashbreak:resolve_error
```

### AWS
Do not send any private / sensitive data to crashbreak, instead of this use your AWS to store it and send us only url or file name. AWS is required for database dumper and restorer.
```ruby
config.dumper_options = {
  aws_bucket_name: 'cb-test-app',
  aws_region: 'us-east-1',      # default: ENV['AWS_REGION']
  aws_access_key_id: 'xxx',     # default: ENV['AWS_ACCESS_KEY_ID']
  aws_secret_access_key: 'xxx', # default: ENV['AWS_SECRET_ACCESS_KEY']
}
```

## Adapt crashbreak to your system and flow!
Read more about flow and extensions [here](http://www.crashbreak.com/how_we_use_crashbreak/).

Create your own plugin and improve current functionality - [become a collaborator!](http://www.crashbreak.com/extensions#contributing)

### Request store
Crashbreak uses [request store gem](https://github.com/steveklabnik/request_store) to store data and pass it to serializers and dumpers. By default it stores controller and exception instance and request object but you can add more.

#### All crashbreak options can be found [here](https://github.com/crashbreak/crashbreak/blob/master/lib/crashbreak/config/configurator.rb).

## Contributing

1. Fork it ( https://github.com/crashbreak/crashbreak/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
