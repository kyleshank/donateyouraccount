##
# Donate Your Account (donateyouraccount.com)
# Copyright (C) 2014  Kyle Shank (kyle.shank@gmail.com)
# http://www.gnu.org/licenses/agpl.html
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
# 
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
##
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

	it "should allow a person signed in with Facebook to manage a Campaign if they are an admin of the Facebook page" do
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

		FakeWeb.register_uri(:get, "https://graph.facebook.com/234324/feed",
                     :content_type => "application/json",
                     :body => json_fixture('facebook/feed.json', :id => facebook_page_uid))

    FakeWeb.register_uri(:get, "https://graph.facebook.com/234324_108471362651205",
                     :content_type => "application/json",
                     :body => json_fixture('facebook/post.json', :id => "234324_108471362651205", :page_id=>"234324"))

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

		ApplicationController.any_instance.stub(:current_facebook_account).and_return(nil)

		get '/signout'
		last_response.status.should == 302
		last_response.headers["Location"].should match /^http\:\/\/.+\/$/
		follow_redirect!

		last_response.status.should==200

		campaign= Campaign.where(permalink: "test2").first

		account2 = create(:facebook_account, uid: "7890123", facebook_pages: pages)

		ApplicationController.any_instance.stub(:current_facebook_account).and_return(account2)

		get '/'
		last_response.status.should == 302
		last_response.headers["Location"].should match /^http\:\/\/.+\/home$/
		follow_redirect!

		last_response.body.match("<li><a href=\"/test2\">My Facebook Campaign Update</a></li>").should_not be_nil

		get '/test2'
		last_response.status.should==200

		last_response.body.match("Publish Facebook").should_not be_nil
		last_response.body.match("Edit Campaign").should_not be_nil

		get edit_campaign_path(campaign)
		last_response.status.should==200
		put campaign_path(campaign), {campaign: {name: "My Facebook Campaign Update 2", permalink: "test2", description: "My description", facebook_page_uid: facebook_page_uid}}
		last_response.status.should==200

		get new_campaign_facebook_status_path(campaign)
    last_response.status.should==200

    post campaign_facebook_statuses_path(campaign), {facebook_status: {"uid" => "#{facebook_page_uid}_108471362651205", "levels" => ["2"]}}
    last_response.status.should==302
    last_response.headers["Location"].should match /^http\:\/\/.+\/test2$/
    follow_redirect!

    last_response.status.should==200
    campaign.facebook_statuses.count.should==1

    campaign.facebook_statuses.first.publish
	end
end