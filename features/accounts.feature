Feature: Accounts
	
@redirect	
Scenario: A user with no accounts see's new account page
	Given the user has a user record
	When she logs in
	Then she should see "Let's set up your family account."


