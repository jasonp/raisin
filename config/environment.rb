# Load the Rails application.
require File.expand_path('../application', __FILE__)

ActionMailer::Base.smtp_settings = {
  :address        => 'smtp.sendgrid.net',
  :port           => '587',
  :authentication => :plain,
  :user_name      => 'app36071197@heroku.com',
  :password       => 'zxbgfdfz',
  :domain         => 'raisinhq.com',
  :enable_starttls_auto => true
}


# Initialize the Rails application.
Rails.application.initialize!
