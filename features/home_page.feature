Feature: Home Page
	
Scenario: Viewing raisin's home page
	When I go to the home page
	Then I should see "most important startup"
	And I should see "Projects"
	And I should see "Copyright (c) 2015"
