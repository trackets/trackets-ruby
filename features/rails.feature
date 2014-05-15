Feature: Gem works in Rails application

  Background:
    Given I'm in a new Rails application named "trackets_test"

  Scenario: Rescue an exception in a controller
    When I configure an app to use Trackets
    And I define action "test#index" to
      """
      raise "This is testing error"
      """
    And I define route "/test" to "test#index"
    And I request "http://foo.bar:31337/test"
    Then I should receive notification to Trackets server
