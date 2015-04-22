Feature: Accounts
	
@accounts	
Scenario: A logged in user can create an account
	Given a logged-in user
	When she creates an account
	Then she should see "All set! Welcome to Raisin."




