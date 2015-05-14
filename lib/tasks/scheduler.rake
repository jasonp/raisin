desc "This task is called by the Heroku scheduler add-on"
task :morning_digest => :environment do
  puts "Sending to-do reminder emails..."
  RaisinRoutines.send_daily_todo_summary_email
  puts "done."
end

