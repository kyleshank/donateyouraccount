Feature: Donation
  As a User
  I want to donate my account
  So that I can support the campaign

  Scenario: Donate Twitter Account to Campaign
    Given there is a Twitter campaign "TwitterCampaign"
    Given there is a Twitter account "donor"
    Given I am on the home page
      And I sign in as Twitter account "donor"
      And I am on "TwitterCampaign" campaign
      And I should see "@donor" within "#nav"
      And I should see "Donate" within "#donate_twitter"
      And I click "donate_twitter"
    Then I should see "Choose the level of your donation"
      And I accept the confirmation dialog
      And I press "Donate Your Twitter Account"
    Then I should see "Twitter Donors"
      And I should not see "Facebook Donors"

  Scenario: Donate Facebook Account to Campaign
    Given there is a Facebook campaign "FacebookCampaign"
    Given there is a Facebook account "Mr Pants"
    Given I am on the home page
      And I sign in as Facebook account "Mr Pants"
      And I am on "FacebookCampaign" campaign
      And I should see "Mr Pants" within "#nav"
      And I should not see "#donate_twitter"
      And I should see "Donate" within "#donate_facebook"
      And I click "donate_facebook"
    Then I should see "Choose the level of your donation"
      And I accept the confirmation dialog
      And I press "Donate Your Facebook Account"
    Then I should not see "Twitter Donors"
      And I should see "Facebook Donors (1)"

  Scenario: Donate Twitter and Facebook Account to Campaign
    Given there is a campaign "TwitterFacebookCampaign"
    Given there is a Twitter account "donor"
    Given there is a Facebook account "Mr Pants"
    Given I am on the home page
      And I sign in as Twitter account "donor"
      And I am on "TwitterFacebookCampaign" campaign
      And I should see "@donor" within "#nav"
      And I click "donate_twitter"
    Then I should see "Choose the level of your donation"
      And I accept the confirmation dialog
      And I press "Donate Your Twitter Account"
    Then I should see "Twitter Donors (1)"
      And I should see "Facebook Donors (0)"
    Then I sign in as Facebook account "Mr Pants"
      And I am on "TwitterFacebookCampaign" campaign
      And I should see "Mr Pants" within "#nav"
      And I click "donate_facebook"
    Then I should see "Choose the level of your donation"
      And I accept the confirmation dialog
      And I press "Donate Your Facebook Account"
    Then I should see "Twitter Donors (1)"
      And I should see "Facebook Donors (1)"
