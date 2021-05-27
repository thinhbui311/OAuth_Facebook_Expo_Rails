Feature: Login page by OAuth Facebook
  Scenario: View home page
    Given I am on the home page
    Then I should see login button

  Scenario: Press login button but not authorize
    Given I am on the home page
    When I click login button then Facebook authorize window show up and close window
    Then I should see login button
