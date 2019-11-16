Feature: Deep link navigator push promises
  A push should be able to return a future result from a pop.

  Scenario: Cancelling (un)authentication does nothing when already authenticated
    Given I tap the "login" button
    And I tap the "user" button
    And I tap the "authentication chooser" button
    And the title is "Authentication"
    When I go back 1 time
    And I tap the "favorites" button
    Then the title is "My favorites (3)"

  Scenario: Authenticating does nothing when already authenticated
    Given I tap the "login" button
    And I tap the "user" button
    And I tap the "authentication chooser" button
    And the title is "Authentication"
    When I tap the "authenticate" button
    And I tap the "favorites" button
    Then the title is "My favorites (3)"

  Scenario: Unauthenticating redirects to login screen on navigation attempt
    Given I tap the "login" button
    And I tap the "user" button
    And I tap the "authentication chooser" button
    And the title is "Authentication"
    When I tap the "unauthenticate" button
    And I tap the "favorites" button
    Then the title is "Login"

