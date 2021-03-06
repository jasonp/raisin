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
	And I should see "Sign up with Facebook"
	
@signup
Scenario: A user signs up
	When a user signs up
	Then I should see "All set! Welcome to Raisin."
	
@signin	
Scenario: A user signs in
	Given the user has an account
	When she logs in
	Then I should see "Signed in successfully."
	
@update
Scenario: A user updates their info
	Given the user has an account
	When she logs in
	When she updates her information
	Then I should see "Great success! New information saved."
	

