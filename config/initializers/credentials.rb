# Place to set credentials as global variables
#


SENDGRID_USERNAME = "app36071197@heroku.com"
SENDGRID_PASSWORD = "zxbgfdfz"


if Rails.env == 'production'
  Stripe.api_key = ""
  STRIPE_PUBLIC_KEY = ""
else
  Stripe.api_key = ""
  STRIPE_PUBLIC_KEY = ""
end


if Rails.env == 'production'
  Sidekiq.configure_server do |config|
    config.redis = { url: 'redis://rediscloud:jdMbOCF90FOTAnml@pub-redis-15632.us-east-1-3.3.ec2.garantiadata.com:15632' }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: 'redis://rediscloud:jdMbOCF90FOTAnml@pub-redis-15632.us-east-1-3.3.ec2.garantiadata.com:156322' }
  end
end

