# Place to set credentials as global variables
#


SENDGRID_USERNAME = "app36071197@heroku.com"
SENDGRID_PASSWORD = "zxbgfdfz"


if Rails.env == 'production'
  STRIPE_PUBLIC_KEY = "pk_or8LqI1qmdDoigvCHvFIRT4Jeurpn"
else
  STRIPE_PUBLIC_KEY = "pk_wCSzBjODUCaz5T7sgpOTvxwdMWidy"
end



