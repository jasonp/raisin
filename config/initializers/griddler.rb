Griddler.configure do |config|
  config.processor_class = EmailProcessor # MyEmailProcessor
  config.processor_method = :process # The `process` part of MyEmailProcessor.new(email).process
  config.reply_delimiter = '--- REPLY ABOVE THIS LINE TO RESPOND IN RAISIN ---'
  config.email_service = :sendgrid
end