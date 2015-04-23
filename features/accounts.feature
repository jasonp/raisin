Feature: Accounts
	
@redirect	
Scenario: A user with no accounts see's new account page
	Given the user has a user record
	When she logs in
	Then she should see "Let's set up your family account."


@redirect	
Scenario: A user with one account sees the account page
	Given the user has a user record
	And she has 1 family accounts
	When she logs in
	Then she should see "Example Family"

@redirect	
Scenario: A user with many accounts sees the account index
	Given the user has a user record
	And she has 3 family accounts
	When she logs in
	Then she should see "part of more than one family!"
