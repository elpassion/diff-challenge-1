Feature: User sign in
  Scenario: User signs in
    Given the following user exist
      | email            | foo.bar@example.net  |
      | password         | Very strong password |
    When  I navigate to "sign_in" screen
    And   I fill field "email" with "foo.bar@example.com"
    And   I fill field "password" with "Very strong password"
    And   I click on "Sign In" button
    Then  I should see "Welcome!" within "main" container

  Scenario: User provides wrong password
    Given the following user exist
      | email            | foo.bar@example.net  |
      | password         | Very strong password |
    When  I navigate to "sign_in" screen
    And   I fill field "email" with "foo.bar@example.com"
    And   I fill field "password" with "Wrong password"
    And   I click on "Sign In" button
    Then  I should see "Login or password incorrect." within "main" container
