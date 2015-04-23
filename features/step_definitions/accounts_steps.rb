Given /^a logged-in user$/ do
  @user = User.create!(:email => "example@example.com", :password => "godzilla", :password_confirmation => "godzilla") 
  visit(new_user_session_path)
  fill_in('Email', :with => "example@example.com")
  fill_in('Password', :with => "godzilla")
  click_button('Log in') 
end

Given /^the user has a user record$/ do
  @user = User.create!(:email => "example@example.com", :password => "godzilla", :password_confirmation => "godzilla") 
end


When /^she creates an account$/ do
  visit('/accounts/new')
  fill_in('Pick a family account name', :with => "Example Family")
  click_button('Take me to my dashboard')
end

Then(/^she should see "(.*?)"$/) do |arg1|
  page.should have_content(arg1)
end


Given /^she has (\d+) family accounts$/ do |num|
  n = num.to_i
  n.times { @user.accounts.create(:name => "Example Family") }
end