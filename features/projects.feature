Feature: Projects & Members
	
@projects	
Scenario: A logged-out user sees the login page
	When she visits the new projects page
	Then she should see "You need to sign in or sign up before continuing."


@projects
Scenario: A logged-in user with an invalid account number sees new accounts page
	When a user signs up
	When she visits an invalid new projects page
	Then she should see "My family account name"


@projects	
Scenario: A logged-in user with an account can create a project
	When a user signs up
	When she creates a project
	Then she should see "Example Project"
	And she should see "With an example description"

@projects	
Scenario: A logged-in user with a project should see it listed on the account page
	Given a user with a permanent project
	When she creates a project
	And she visits her dashboard
	Then she should see "Family Members"

@projects	
Scenario: A logged-in user can update a project
	Given a user with a permanent project
	When she creates a project
	When she tries to edit a project
	Then she should find "Update the project"

@projects	
Scenario: A logged-in user cannot update a permanent project
	Given a user with a permanent project
	When she tries to edit a permanent project
	Then she should see "Family Members"

@projects	
Scenario: A project can be put in the garage
	Given a user with a permanent project
	When she creates a project
	And she puts the project in the garage
	Then she should not see "Example Project"

@projects	
Scenario: A logged-in user should get a permanent project when they create an account
	Given a user with a permanent project
	When I go to the home page
	Then she should see "Family Members"

@projects	
Scenario: A logged-in user with a project can add or invite members to the project
	Given a user with a permanent project
	When she creates a project
	And she adds a member to the project
	Then she should see "Invited Member"
	

@projects	
Scenario: A logged-in user with an account can add or invite members to the account
	Given a user with a permanent project
	When she adds a non participating member to the account
	Then she should see "Invited Member"
	
@projects	
Scenario: A logged-in user with an account can add or invite members to the account
	Given a user with a permanent project
	When she adds a participating member to the account
	Then she should see "Invited Participant"
	
@projects	
Scenario: A logged in user cannot edit a project they did not create
	Given a project exists
	When a user signs up
	And she tries to edit the project
	Then she should see "Family Members"
	

