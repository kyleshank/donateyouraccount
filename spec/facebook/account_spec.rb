require 'spec_helper'

describe FacebookAccount do
	def app
  	Dya::Application
	end

	it "should connect a valid Facebook account" do
		# Redirect user to Facebook
		get(new_facebook_account_path)
		last_response.status.should == 302
		last_response.headers["Location"].should match /^https\:\/\/graph.facebook.com\/oauth\/authorize/

		# Accept post back from Facebook
		FakeWeb.register_uri(:post, "https://graph.facebook.com/oauth/access_token",
                         :content_type => "application/json",
                         :body => json_fixture('facebook/oauth_access_token'))

		FakeWeb.register_uri(:get, /^https:\/\/graph.facebook.com\/oauth\/access_token.+/,
                         :body => "access_token=324893248977342&expires=5332343")

		facebook_uid = "123456"

		FakeWeb.register_uri(:get, "https://graph.facebook.com/me",
                     :content_type => "application/json",
                     :body => json_fixture('facebook/me.json', :uid => facebook_uid))

		FakeWeb.register_uri(:get, "https://graph.facebook.com/me/friends",
                     :content_type => "application/json",
                     :body => json_fixture('facebook/friends.json', :uid => facebook_uid))

		FakeWeb.register_uri(:get, "https://graph.facebook.com/me/accounts",
                     :content_type => "application/json",
                     :body => json_fixture('facebook/accounts.json', :uid => facebook_uid))

		post(facebook_accounts_path+"?code=324324934")
		last_response.status.should == 302
		last_response.headers["Location"].should match /^http\:\/\/.+\/home$/

		FacebookAccount.count.should==1
	end

	it "should allow a person signed in with Facebook to create a Campaign" do
		# Accept post back from Facebook
		FakeWeb.register_uri(:post, "https://graph.facebook.com/oauth/access_token",
                         :content_type => "application/json",
                         :body => json_fixture('facebook/oauth_access_token'))

		FakeWeb.register_uri(:get, /^https:\/\/graph.facebook.com\/oauth\/access_token.+/,
                         :body => "access_token=324893248977342&expires=5332343")

		facebook_page_uid = "234324"

		FakeWeb.register_uri(:get, "https://graph.facebook.com/234324",
                     :content_type => "application/json",
                     :body => json_fixture('facebook/page.json', :id => facebook_page_uid))

		pages = <<-EOS
[{
  "name": "Donate Your Account", 
  "access_token": "testToken", 
  "category": "Community", 
  "id": "#{facebook_page_uid}", 
  "perms": [
    "ADMINISTER", 
    "EDIT_PROFILE", 
    "CREATE_CONTENT", 
    "MODERATE_CONTENT", 
    "CREATE_ADS", 
    "BASIC_ADMIN"
  ]
}]
		EOS

		account = create(:facebook_account, uid: "123456", facebook_pages: pages)

		ApplicationController.any_instance.stub(:current_facebook_account).and_return(account)

		get '/'
		last_response.status.should == 302
		last_response.headers["Location"].should match /^http\:\/\/.+\/home$/
		follow_redirect!

		get new_campaign_path
		last_response.status.should==302
		last_response.headers["Location"].should=="http://example.org/facebook_accounts/new?manage_pages=true&return_to=%2Fcampaigns%2Fnew"
		follow_redirect!

		get new_campaign_path

		post campaigns_path, {campaign: {name: "My Facebook Campaign", permalink: "test", description: "My description", facebook_page_uid: facebook_page_uid}}
		last_response.status.should==302
		last_response.headers["Location"].should match /^http\:\/\/.+\/test$/
		follow_redirect!

		last_response.status.should==200

		Campaign.where(permalink: "test").count.should==1

		campaign= Campaign.where(permalink: "test").first

		get edit_campaign_path(campaign)
		last_response.status.should==200
		put campaign_path(campaign), {campaign: {name: "My Facebook Campaign Update", permalink: "test2", description: "My description", facebook_page_uid: facebook_page_uid}}
		last_response.status.should==200
	end

	it "should sign out a logged in Facebook account" do
		account = create(:facebook_account, uid: "123456")

		ApplicationController.any_instance.stub(:current_facebook_account).and_return(account)

		get '/'
		last_response.status.should == 302
		last_response.headers["Location"].should match /^http\:\/\/.+\/home$/
		follow_redirect!

		ApplicationController.any_instance.stub(:current_facebook_account).and_return(nil)

		get '/signout'
		last_response.status.should == 302
		last_response.headers["Location"].should match /^http\:\/\/.+\/$/
		follow_redirect!

		last_response.status.should==200
	end
end