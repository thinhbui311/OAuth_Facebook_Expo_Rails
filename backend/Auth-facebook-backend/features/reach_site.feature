Feature: Login page by OAuth Facebook
  Scenario: View home page
    Given I am on the home page
    Then I should see login button

  Scenario: Press login button but not authorize
    Given I am on the home page
    When I click loggin button
    Then Facebook authorize window show up
    But I turn off authorize window
    Then I get back to home page

  Scenario: Press login button and authorize
    Given I am on the home page
    When I click loggin button
    Then Facebook authorize window show up
    And I click to accept authorize
    Then I can see my facebook info
    And I click logout button
    Then I get back to home page
