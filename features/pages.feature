Feature: Pages
	
Scenario: Viewing Raisin's home page without logging in
	When I go to the home page
	Then I should see "most important startup"
	And I should see "Copyright (c) 2015"
	And I should see "Log in"

@signup
Scenario: Viewing Raisin's sign up page
	When I go to the sign up page
	Then I should see "Sign up"
	And I should see "Sign in with Facebook"
	
@signup
Scenario: A user signs up
	When a user signs up
	Then I should see "You have signed up successfully."
	
@signin	
Scenario: A user signs in
	Given the user has an account
	When she logs in
	Then I should see "Signed in successfully."
	