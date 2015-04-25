When(/^she visits an invalid new projects page$/) do 
  visit('/accounts/9872349/projects/new')
end

When(/^she visits the new projects page$/) do
  visit('/accounts/1/projects/new')
end

When /^she creates a project$/ do
  visit('/accounts/1/projects/new')
  fill_in('project_title', :with => "Example Project")
  fill_in('project_description', :with => "With an example description")
  click_button('Create a new project')
end

Given /^a user with a permanent project$/ do
  visit('accounts/new')
  fill_in('My full name', :with => "Example Person")
  fill_in('My email address', :with => "example@example.com")
  fill_in('Password', :with => "godzilla")
  fill_in('Password confirmation', :with => "godzilla")
  fill_in('My family account name', :with => "My Family")
  click_button('Take me to my dashboard')
end

When /^she visits her dashboard$/ do
  visit(root_path)
end

Then(/^she should find "(.*?)"$/) do |arg1|
  page.should have_button(arg1)
end

When /^she tries to edit a permanent project$/ do
  visit('/accounts/1/projects/1/edit')
end

When /^she tries to edit a project$/ do
  @found_account = Account.find_by_name("My Family")
  @editable_project = Project.new(title: "Editable Project", description: "Unncesseary", account_id: @found_account.id).save!
  visit(edit_account_project_path(@found_account, @editable_project))
end

When(/^she puts the project in the garage$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^she should not see "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

When(/^she adds a member to the project$/) do
  visit('/accounts/1/projects/2')
  click_link('Invite a new collaborator')
  fill_in('Name', :with => "Invited Member")
  fill_in('Email', :with => "invited@prestons.me")
  click_button('Send inviation')
end

When(/^she adds a non participating member to the account$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^she adds a participating member to the account$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^a project exists$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^she tries to edit the project$/) do
  pending # express the regexp above with the code you wish you had
end
