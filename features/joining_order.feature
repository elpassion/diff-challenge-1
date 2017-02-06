Feature: Joining order
  Scenario: User joins order
    Given the following order exist
      | restaurant       | The Place  |
    Given I'm "John Doe" user
    When  I sign in
    And   I click on "Join The Place order" button
    And   I fill field "Your meal" with "Pierogi ruskie"
    And   I fill field "Your meal price" with "12"
    And   I click button "Join"
    Then  I should see "John Doe - Pierogi ruskie - 12 PLN" within "[data-order=The Place]" container

  Scenario: User unjoins order
    Given the following order exist
      | restaurant       | The Place  |
    Given the following dish exist
      | meal_eater       | Haruki Murakami |
      | meal_name        | Pierogi ruskie |
      | meal_price       | 12  |
    Given I'm "Haruki Murakami" user
    When  I sign in
    And   I click on "Remove dish" button
    Then  I should see "Your dish (Pierogi ruskie) was removed"
    And   I should not see "Haruki Murakami - Pierogi ruskie" within "[data-order=The Place]" container

  Scenario: User tries to unjoin other user order
    Given the following order exist
      | restaurant       | The Place  |
    Given the following dish exist
      | meal_eater       | Piggy |
    Given I'm "Kermit the Frog" user
    When  I sign in
    And   I click on "Remove dish" button
    Then  I should see "Only dish creator can remove dish"

