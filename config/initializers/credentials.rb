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
  REDIS_PROVIDER=REDISCLOUD_URL
end
