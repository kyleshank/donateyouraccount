require 'spec_helper'

describe Campaign do
	def app
  	Dya::Application
	end

	it "should show a campaign" do
		account = create(:twitter_account, uid: "123456")
		campaign = create(:campaign, twitter_account_id: account.id, permalink: "test")
		get '/test'
		last_response.status.should==200
	end

	it "should show a 404 if campaign doesn't exist" do
		get '/test'
		last_response.status.should==404
	end

	it "should show a list of campaigns" do
		get '/campaigns'
		last_response.status.should==200
	end

	it "should delete a campaign" do
		account = create(:twitter_account, uid: "123456")
		campaign = create(:campaign, twitter_account_id: account.id, permalink: "test")
		ApplicationController.any_instance.stub(:current_twitter_account).and_return(account)

		get campaign_path(campaign)
		last_response.status.should==200

		get edit_campaign_path(campaign)
		last_response.status.should==200

		delete campaign_path(campaign)
		last_response.status.should==302
		last_response.headers["Location"].should match /^http\:\/\/.+\/home$/
		follow_redirect!

		get campaign_path(campaign)
		last_response.status.should==404
	end

	it "should disallow a non logged in user to edit a campaign" do
		account = create(:twitter_account, uid: "123456")
		campaign = create(:campaign, twitter_account_id: account.id, permalink: "test")
		get edit_campaign_path(campaign)
		last_response.status.should==302
		last_response.headers["Location"].should match /^http\:\/\/.+\/$/
	end
end