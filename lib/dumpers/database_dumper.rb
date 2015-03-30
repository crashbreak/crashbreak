class Crashbreak::DatabaseDumper
  def dump
    dump_database
    prepare_aws
    upload_dump
    remove_locally_dump
  end

  private

  def dump_database
    system(dump_command)
  end

  def prepare_aws
    Aws.config.update(
        credentials: Aws::Credentials.new(aws_key_id, aws_secret_key),
        s3: { region: aws_region }
    )
  end

  def upload_dump
    client.put_object(bucket: bucket_name, key: "Crashbreak - database dump #{DateTime.now.utc}", body: File.read(dump_location))
  end

  def remove_locally_dump
    File.delete(dump_location)
  end

  def client
    @client ||= Aws::S3::Client.new
  end

  def bucket_name
    Crashbreak.configure.dumper_options[:aws_bucket_name]
  end

  def aws_region
    Crashbreak.configure.dumper_options[:aws_region] || ENV['AWS_REGION']
  end

  def aws_key_id
    Crashbreak.configure.dumper_options[:aws_access_key_id] || ENV['AWS_ACCESS_KEY_ID']
  end

  def aws_secret_key
    Crashbreak.configure.dumper_options[:aws_secret_access_key] || ENV['AWS_SECRET_ACCESS_KEY']
  end

  def dump_location
    Crashbreak.configure.dumper_options[:dump_location]
  end

  def dump_command
    Crashbreak.configure.dumper_options[:dump_command]
  end
end