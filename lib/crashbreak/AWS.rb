module Crashbreak
  module AWS
    def client
      @client ||= Aws::S3::Client.new
    end

    def aws_resource_bucket
      @aws_resource_bucket ||= Aws::S3::Resource.new.bucket(bucket_name)
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

    def prepare_aws
      Aws.config.update(
          credentials: Aws::Credentials.new(aws_key_id, aws_secret_key),
          s3: { region: aws_region }
      )
    end
  end
end