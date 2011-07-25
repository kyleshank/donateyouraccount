Feature: Campaign
  As a User
  I want to create a campaign
  So that I can accept donations

  Scenario: Create Campaign with Twitter
    Given there is a Twitter account "kyleshank"
    When I am on the home page
      And I sign in as Twitter account "kyleshank"
    Then I click "Create Campaign"
      And I fill in "campaign_name" with "My Twitter Campaign"
      And the "campaign_permalink" field should contain "kyleshank"
      And I should see "Twitter account"
      And I should see "Sign in with Facebook"
      And I fill in "campaign_description" with "My Twitter campaign is so awesome you should donate to it!"
      And I press "Create Campaign"
    Then I should see "My Twitter Campaign"

  Scenario: Create Campaign with Facebook
    Given there is a Facebook account "Kyle Shank"
    When I am on the home page
      And I sign in as Facebook account "Kyle Shank"
    Then I click "Create Campaign"
      And I fill in "campaign_name" with "My Facebook Campaign"
      And I fill in "campaign_permalink" with "facebookpage"
      And I should see "Facebook page"
      And I select "Donate Your Account" from "campaign_facebook_page_uid"
      And I should see "Sign in with Twitter"
      And I fill in "campaign_description" with "My Facebook campaign is so awesome you should donate to it!"
      And I press "Create Campaign"
    Then I should see "My Facebook Campaign"

  Scenario: Create Campaign with both Twitter and Facebook
    Given there is a Twitter account "kyleshank"
    Given there is a Facebook account "Kyle Shank"
    When I am on the home page
      And I sign in as Twitter account "kyleshank"
      And I sign in as Facebook account "Kyle Shank"
    Then I click "Create Campaign"
      And I fill in "campaign_name" with "My Twitter AND Facebook Campaign"
      And the "campaign_permalink" field should contain "kyleshank"
      And I fill in "campaign_permalink" with "facebooktwitter"
      And I should not see "Sign in with Twitter"
      And I should not see "Sign in with Facebook"
      And I select "@kyleshank" from "campaign_twitter_account_id"
      And I select "Donate Your Account" from "campaign_facebook_page_uid"
      And I fill in "campaign_description" with "My Twitter and Facebook campaign is so awesome you should donate to it!"
      And I press "Create Campaign"
    Then I should see "My Twitter AND Facebook Campaign"