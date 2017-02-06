Feature: Managing order
  Scenario: User creates order
    Given I'm user
    When  I sign in
    And   I click on "New Order" button
    And   I fill field "restaurant" with "The Place"
    And   I fill field "ordering_time_hour" with "12"
    And   I fill field "ordering_time_minutes" with "45"
    And   I click on "Create Order" button
    Then  I should see "Order successfully created!"
    And   I should see "The Place" within "orders_list" container

  Scenario: User removes order
    Given the following order exist
      | founder          | John Doe |
      | restaurant       | The Place  |
    Given I'm "John Doe" user
    When  I sign in
    Then  I should see "The Place" within "orders_list" container
    When  I click on "Remove Order" button
    Then  I should see "Order successfully removed!"
    And   I should not see "The Place" within "orders_list" container

  Scenario: User who is not founder tries to remove order
    Given the following order exist
      | founder          | Steven Seagal |
    Given I'm "Emma Stone" user
    When  I sign in
    When  I click on "Remove Order" button
    Then  I should see "Only order founder can remove order"

  Scenario: Order founder draws executor
    Given the following order exist
      | founder          | John Doe |
      | restaurant       | The Place  |
    Given 2 dishes in The Place order exist
    Given I'm "John Doe" user
    When  I sign in
    When  I click button "Draw executor"
    Then  I should see random user name within "executor" container

  Scenario: User who is not founder tries to draw executor
    Given the following order exist
      | founder          | John Doe |
    Given 2 dishes in The Place order exist
    Given I'm "Emma Stone" user
    When  I sign in
    When  I click button "Draw executor"
    Then  I should see "Only order founder can draw executor"
