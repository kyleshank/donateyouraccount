require 'spec_helper'

describe Donation do
	def app
  	Dya::Application
	end

	it "should donate and un-donate a Twitter account" do
		account = create(:twitter_account, uid: "123456")
		campaign_account = create(:twitter_account, uid: "6789")
		campaign = create(:campaign, twitter_account_id: campaign_account.id, permalink: "test")

		ApplicationController.any_instance.stub(:current_twitter_account).and_return(account)

		get campaign_path(campaign)
		last_response.status.should==200

		get twitter_campaign_donations_path(campaign)
		last_response.status.should==200

		post twitter_campaign_donations_path(campaign), {donation: {level: Donation::LEVELS["Silver"]}}
		last_response.status.should==302
		last_response.headers["Location"].should match /^http\:\/\/.+\/test$/
		follow_redirect!
		
		campaign.donations.count.should==1

		last_response.status.should==200

		donation = account.donations.first

		get delete_campaign_donation_path(campaign,donation)
		last_response.status.should==200

		delete campaign_donation_path(campaign,donation)
		last_response.status.should==302
		last_response.headers["Location"].should match /^http\:\/\/.+\/test$/
		follow_redirect!

		last_response.status.should==200

		campaign.donations.count.should==0
	end
end