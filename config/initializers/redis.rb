
if Rails.env == 'production'
  uri = URI.parse("redis://rediscloud:jdMbOCF90FOTAnml@pub-redis-15632.us-east-1-3.3.ec2.garantiadata.com:15632")
  $redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end