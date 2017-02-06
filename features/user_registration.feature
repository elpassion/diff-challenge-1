Feature: User registration
  Scenario: User creates account
    When  I navigate to "sign_up" screen
    And   I fill field "email" with "foo.bar@example.com"
    And   I fill field "password" with "Very strong password"
    And   I fill field "password_confirmation" with "Very strong password"
    And   I click on "Sign In" button
    Then  I should see "Your account has been created!" within "main" container

  Scenario: User provides passwords which don't match
    When  I navigate to "sign_up" screen
    And   I fill field "email" with "foo.bar@example.com"
    And   I fill field "password" with "Very strong password"
    And   I fill field "password_confirmation" with "Another password"
    And   I click on "Sign In" button
    Then  I should see "Password and password confirmation don't match." within "main" container
