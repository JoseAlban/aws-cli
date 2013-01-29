require 'aws-sdk'

class AwsCli

  def self.authentication_details
    aws_access_key_id = ENV['AWS_ACCESS_KEY_ID']
    raise "AWS_ACCESS_KEY_ID not set." if !aws_access_key_id

    aws_secret_key = ENV['AWS_SECRET_KEY']
    raise "AWS_SECRET_KEY not set." if !aws_secret_key

    {
      :access_key_id => aws_access_key_id,
      :secret_access_key => aws_secret_key
    }
  end

  def self.region
    ENV["AWS_REGION"] || "eu-west-1"
  end

  def self.create_sns_client
    set_proxy
    config = {
      :sns_endpoint => "sns.#{region}.amazonaws.com",
      :max_retries => 2
    }
    config = authentication_details.merge(config)
    AWS::SNS.new(config)
  end

  def self.create_sqs_client
    set_proxy
    config = {
      :sqs_endpoint => "sqs.#{region}.amazonaws.com",
      :max_retries => 2
    }
    config = authentication_details.merge(config)
    AWS::SQS.new(config)
  end

  def self.create_sdb_client
    set_proxy
    config = {
      :simple_db_endpoint => "sdb.#{region}.amazonaws.com",
      :simple_db_consistent_reads => true,
      :max_retries => 2
    }
    config = authentication_details.merge(config)
    AWS::SimpleDB.new(config)
  end

  def self.create_s3_client
    set_proxy
    config = {
      :s3_endpoint => "s3-#{region}.amazonaws.com",
      :max_retries => 2
    }
    config = authentication_details.merge(config)
    AWS::S3.new(config)
  end

  def self.set_proxy
    AWS.config({
      :proxy_uri => get_proxy
    })
  end

  def self.get_proxy
    e = ENV['https_proxy']
    e = "https://#{e}" if e && !e.empty? && !e.start_with?('https://')
    return e
  end
end
