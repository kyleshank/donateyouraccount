Feature: Sign in
  As a User
  I want to sign in
  So that I can donate my account

  Scenario: Twitter sign in
    When I am on the home page
      And I should see "Sign in with Twitter"
      And I sign in as Twitter account "kyleshank"
    Then I should see "@kyleshank"

  Scenario: Facebook sign in
    When I am on the home page
      And I should see "Sign in with Facebook"
      And I sign in as Facebook account "Kyle Shank"
    Then I should see "Kyle Shank"

  Scenario: Sign in with both Facebook and Twitter
    When I am on the home page
      And I should see "Sign in with Twitter"
      And I sign in as Twitter account "kyleshank"
    Then I should see "@kyleshank" within "#nav"
      And I should not see "Kyle Shank" within "#nav"
    When I am on the home page
      And I sign in as Facebook account "Kyle Shank"
    Then I should see "Kyle Shank" within "#nav"
      And I should see "@kyleshank" within "#nav"