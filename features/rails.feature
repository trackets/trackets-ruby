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

  Scenario: Send filtered params to Trackets when there's exception in Rails
    When I configure an app to use Trackets
    And I define action "test#index" to
      """
      raise "This is testing error"
      """
    And I define route "/test" to "test#index"
    And I request "http://foo.bar:31337/test?cvv=7739&name=John"
    Then I should receive notification to Trackets server
    And last notice params for key "name" is "John"
    And last notice params for key "cvv" is "[FILTERED]"
    And last notice params should not contain "7739"
