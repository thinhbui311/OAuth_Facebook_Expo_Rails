Feature: Login page by OAuth Facebook
  Scenario: View home page
    Given I am on the home page
    Then I should see login button

  Scenario: Press login button but not authorize
    Given I am on the home page
    When I click login button
    Then I see facebook authorize window show up
    But I close facebook authorize window
    Then I should see login button

  Scenario: Press login button then authorize but wrong credentials info
    Given I am on the home page
    When I click login button
    Then I see facebook authorize window show up
    And I fill in my credentials but it is wrong
    Then I should see login button

  Scenario: Press login button then authorize with correct credentials info
    Given I am on the home page
    When I click login button
    Then I see facebook authorize window show up
    And I fill in my correct credentials
    Then I can see my facebook info
    Then I click logout button
    Then I should see login button
