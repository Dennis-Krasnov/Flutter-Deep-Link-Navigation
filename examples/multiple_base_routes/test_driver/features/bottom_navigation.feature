Feature: Deep link navigator bottom navigation
  Bottom navigation should appear on every screen and control multiple base routes.

  Scenario: Navigation goes to default page once authenticated
    Given the title is "Login"
    When I tap the "login" button
    Then the title is "Library"

  Scenario: Navigating though bottom navigation
    Given I tap the "login" button
    # Navigate to each screen
    When I tap the "favorites" button
    Then the title is "My favorites (3)"
    When I tap the "user" button
    Then the title is "User"
    When I tap the "library" button
    Then the title is "Library"

  Scenario: Redirects to login screen on unauthenticated navigation attempt
    Given I tap the "login" button
    And I tap the "user" button
    When I tap the "unauthenticated" button
    And I tap the "favorites" button
    Then the title is "Login"

  Scenario: Error screen goes full screen
    Given I tap the "login" button
    When I tap the "Non-existant push" button
    Then the title is "ERROR"
    # Hide bottom navigation
    And the text "Library" disappears
    And the text "Favorites" disappears
    And the text "User" disappears