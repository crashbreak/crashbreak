# Crashbreak [![Version](http://img.shields.io/gem/v/crashbreak.svg)                               ](https://rubygems.org/gems/crashbreak) [![Build Status](https://travis-ci.org/crashbreak/crashbreak.svg?branch=master)](https://travis-ci.org/crashbreak/crashbreak) [![Code Climate](https://codeclimate.com/github/crashbreak/crashbreak/badges/gpa.svg)](https://codeclimate.com/github/crashbreak/crashbreak)

Crashbreak gem is a exception notifier for integration with [crashbreak.com](http://crashbreak.com) for ruby apllications.

## Rails Installation

Add this line to your application's Gemfile:

    gem 'crashbreak'

And then execute from your rails root:

    $ bundle

Generate crashbreak initializer:

    rails generate crashbreak:install your_api_key

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

### Exception notifier
Dumping your system can take some time, in order to improve request response you can use different exception notifier.

```ruby
config.exception_notifier = Crashbreak::ExceptionNotifier.new      # default notifier (one thread)
config.exception_notifier = Crashbreak::ForkExceptionNotifier.new  # creates fork
```

## Contributing

1. Fork it ( https://github.com/crashbreak/crashbreak/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
