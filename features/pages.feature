Feature: Pages
	
Scenario: Viewing Raisin's home page
	When I go to the home page
	Then I should see "most important startup"
	And I should see "Projects"
	And I should see "Copyright (c) 2015"
	And I should see "Log in"

@signup
Scenario: Viewing Raisin's log-in page
	When I go to the log in page
	Then I should see "Log in"