require 'spec_helper'

describe TwitterAccount do
	def app
  	Dya::Application
	end

	it "should connect a valid Twitter account" do
		# Redirect user to Twitter
		FakeWeb.register_uri(:post, "https://api.twitter.com/oauth/request_token",
                         :content_type => "text/html; charset=utf-8",
                         :body => fixture('twitter/oauth_request_token'))
		
		get(new_twitter_account_path)
		last_response.status.should == 302
		last_response.headers["Location"].should match /^https\:\/\/api.twitter.com\/oauth\/authenticate/

		# Accept post back from Twitter
		FakeWeb.register_uri(:post, "https://api.twitter.com/oauth/access_token",
                     :content_type => "text/html; charset=utf-8",
                     :body => fixture('twitter/oauth_access_token'))

		twitter_uid = "123456"

		FakeWeb.register_uri(:get, "https://api.twitter.com/1/account/verify_credentials.json",
                     :content_type => "application/json",
                     :body => json_fixture('twitter/verify_credentials.json', :twitter_uid => twitter_uid))

		post(twitter_accounts_path+"?oauth_verifier=988497ajcivmfjens73j38")
		last_response.status.should == 302
		last_response.headers["Location"].should match /^http\:\/\/.+\/home$/

		TwitterAccount.where(:uid => twitter_uid).count.should==1
	end

	it "should allow a person signed in with Twitter to create a Campaign" do
		account = create(:twitter_account, uid: "123456")

		ApplicationController.any_instance.stub(:current_twitter_account).and_return(account)

		get '/'
		last_response.status.should == 302
		last_response.headers["Location"].should match /^http\:\/\/.+\/home$/
		follow_redirect!

		get new_campaign_path
		last_response.status.should==200

		post campaigns_path, {campaign: {name: "My Twitter Campaign", permalink: "test", description: "My description", twitter_account_id: account.id}}
		last_response.status.should==302
		last_response.headers["Location"].should match /^http\:\/\/.+\/test$/
		follow_redirect!

		last_response.status.should==200

		Campaign.where(permalink: "test").count.should==1

		campaign= Campaign.where(permalink: "test").first

		get edit_campaign_path(campaign)
		last_response.status.should==200
		put campaign_path(campaign), {campaign: {name: "My Twitter Campaign Update", permalink: "test2", description: "My description", twitter_account_id: account.id}}
		last_response.status.should==302
		last_response.headers["Location"].should match /^http\:\/\/.+\/test2$/
		follow_redirect!
		last_response.status.should==200
	end

	it "should sign out a logged in Twitter account" do
		account = create(:twitter_account, uid: "123456")

		ApplicationController.any_instance.stub(:current_twitter_account).and_return(account)

		get '/'
		last_response.status.should == 302
		last_response.headers["Location"].should match /^http\:\/\/.+\/home$/
		follow_redirect!

		ApplicationController.any_instance.stub(:current_twitter_account).and_return(nil)

		get '/signout'
		last_response.status.should == 302
		last_response.headers["Location"].should match /^http\:\/\/.+\/$/
		follow_redirect!

		last_response.status.should==200
	end
end