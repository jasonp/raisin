When(/^I go to the home page$/) do 
  visit(root_path)
end

When(/^I go to the sign up page$/) do 
  visit(new_user_registration_path)
end

Then(/^I should see "(.*?)"$/) do |arg1|
  page.should have_content(arg1)
end

When /^a user signs up$/ do
  visit('accounts/new')
  fill_in('My full name', :with => "Example Person")
  fill_in('My email address', :with => "example@example.com")
  fill_in('Password', :with => "godzilla")
  fill_in('Password confirmation', :with => "godzilla")
  fill_in('My family account name', :with => "My Family")
  click_button('Take me to my dashboard')
end

Given /^the user has an account$/ do
  @user = User.create!(:email => "example@example.com", :password => "godzilla", :password_confirmation => "godzilla")  
end

When /^she logs in$/ do
  visit(new_user_session_path)
  fill_in('Email', :with => "example@example.com")
  fill_in('Password', :with => "godzilla")
  click_button('Log in')
end

When /^she updates her information$/ do
  visit(edit_user_path(@user))
  fill_in('My full name', :with => "Example Person Again")
  click_button('Update')
end