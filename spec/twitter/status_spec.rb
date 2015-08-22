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

describe TwitterStatus do
	def app
  	Dya::Application
	end

	it "should publish a Twitter status" do
		account = create(:twitter_account, uid: "123456")
		donor_account = create(:twitter_account, uid: "234222")
		campaign = create(:campaign, twitter_account_id: account.id, permalink: "test")
		donation = create(:donation, account_id: donor_account.id, campaign_id: campaign.id)

		FakeWeb.register_uri(:get, "https://api.twitter.com/1.1/statuses/user_timeline.json?trim_user=true&count=50&screen_name=testTwitter",
                     :content_type => "application/json",
                     :body => json_fixture('twitter/tweets.json', :twitter_uid => account.uid))

		ApplicationController.any_instance.stub(:current_twitter_account).and_return(account)

		get campaign_path(campaign)
		last_response.status.should==200

		get new_campaign_twitter_status_path(campaign)
		last_response.status.should==200

		tweet = <<-TWEET
{
    "created_at": "Sat Nov 17 16:42:53 +0000 2012",
    "id": 269843058630205440,
    "id_str": "269843058630205440",
    "text": "RT @kyleshank: Donate Your Account statement http://t.co/Aj2CG2Zt",
    "truncated": false,
    "in_reply_to_status_id": null,
    "in_reply_to_status_id_str": null,
    "in_reply_to_user_id": null,
    "in_reply_to_user_id_str": null,
    "in_reply_to_screen_name": null,
    "user": {
      "id": #{account.uid},
      "id_str": "#{account.uid}"
    },
    "geo": null,
    "coordinates": null,
    "place": null,
    "contributors": null
}
TWEET

        retweet = <<-TWEET
{
    "created_at": "Sat Nov 17 16:42:53 +0000 2012",
    "id": 269843058630205440,
    "id_str": "269843058630205440",
    "text": "RT @kyleshank: Donate Your Account statement http://t.co/Aj2CG2Zt",
    "truncated": false,
    "in_reply_to_status_id": null,
    "in_reply_to_status_id_str": null,
    "in_reply_to_user_id": null,
    "in_reply_to_user_id_str": null,
    "in_reply_to_screen_name": null,
    "user": {
      "id": #{account.uid},
      "id_str": "#{account.uid}"
    },
    "geo": null,
    "coordinates": null,
    "place": null,
    "contributors": null,
    "retweeted_status" : {
        "created_at": "Sat Nov 17 16:42:53 +0000 2012",
        "id": 269843058630205440,
        "id_str": "269843058630205440",
        "text": "RT @kyleshank: Donate Your Account statement http://t.co/Aj2CG2Zt",
        "truncated": false,
        "in_reply_to_status_id": null,
        "in_reply_to_status_id_str": null,
        "in_reply_to_user_id": null,
        "in_reply_to_user_id_str": null,
        "in_reply_to_screen_name": null,
        "user": {
          "id": #{account.uid},
          "id_str": "#{account.uid}"
        },
        "geo": null,
        "coordinates": null,
        "place": null,
        "contributors": null
    }
}
TWEET

		FakeWeb.register_uri(:get, "https://api.twitter.com/1.1/statuses/show/269843058630205440.json",
                     :content_type => "application/json",
                     :body => tweet)

        FakeWeb.register_uri(:post, "https://api.twitter.com/1.1/statuses/retweet/269843058630205440.json",
                    [
                        {:content_type => "application/json", :body => "", :status => ["500", "Error"]},
                        {:content_type => "application/json", :body => retweet}
                    ]
                    )

		post campaign_twitter_statuses_path(campaign), {twitter_status: {"uid" => 269843058630205440, "levels" => ["2"]}}
		last_response.status.should==302
		last_response.headers["Location"].should match /^http\:\/\/.+\/test$/
		follow_redirect!

		last_response.status.should==200
		campaign.twitter_statuses.count.should==1

        campaign.twitter_statuses.first.publish

        campaign.twitter_statuses.first.donated_statuses.count.should==1
	end

    it "should fail to publish a Twitter status and expire the account" do
        account = create(:twitter_account, uid: "123456")
        donor_account = create(:twitter_account, uid: "234222")
        campaign = create(:campaign, twitter_account_id: account.id, permalink: "test")
        donation = create(:donation, account_id: donor_account.id, campaign_id: campaign.id)

        FakeWeb.register_uri(:get, "https://api.twitter.com/1.1/statuses/user_timeline.json?trim_user=true&count=50&screen_name=testTwitter",
                     :content_type => "application/json",
                     :body => json_fixture('twitter/tweets.json', :twitter_uid => account.uid))

        ApplicationController.any_instance.stub(:current_twitter_account).and_return(account)

        get campaign_path(campaign)
        last_response.status.should==200

        get new_campaign_twitter_status_path(campaign)
        last_response.status.should==200

        tweet = <<-TWEET
{
    "created_at": "Sat Nov 17 16:42:53 +0000 2012",
    "id": 269843058630205440,
    "id_str": "269843058630205440",
    "text": "RT @kyleshank: Donate Your Account statement http://t.co/Aj2CG2Zt",
    "truncated": false,
    "in_reply_to_status_id": null,
    "in_reply_to_status_id_str": null,
    "in_reply_to_user_id": null,
    "in_reply_to_user_id_str": null,
    "in_reply_to_screen_name": null,
    "user": {
      "id": #{account.uid},
      "id_str": "#{account.uid}"
    },
    "geo": null,
    "coordinates": null,
    "place": null,
    "contributors": null
}
TWEET

        FakeWeb.register_uri(:get, "https://api.twitter.com/1.1/statuses/show/269843058630205440.json",
                     :content_type => "application/json",
                     :body => tweet)

        FakeWeb.register_uri(:post, "https://api.twitter.com/1.1/statuses/retweet/269843058630205440.json",
                    [
                        {:content_type => "application/json", :body => "", :status => ["401", "Unauthorized"]}
                    ]
                    )

        post campaign_twitter_statuses_path(campaign), {twitter_status: {"uid" => 269843058630205440, "levels" => ["2"]}}
        last_response.status.should==302
        last_response.headers["Location"].should match /^http\:\/\/.+\/test$/
        follow_redirect!

        last_response.status.should==200
        campaign.twitter_statuses.count.should==1

        campaign.twitter_statuses.first.publish

        campaign.twitter_statuses.first.donated_statuses.count.should==0

        donor_account.reload.expires_at.should_not be_nil
    end

    it "should fail to publish a Twitter status and expire the account because of the Forbidden error" do
        account = create(:twitter_account, uid: "123456")
        donor_account = create(:twitter_account, uid: "234222")
        campaign = create(:campaign, twitter_account_id: account.id, permalink: "test")
        donation = create(:donation, account_id: donor_account.id, campaign_id: campaign.id)

        FakeWeb.register_uri(:get, "https://api.twitter.com/1.1/statuses/user_timeline.json?trim_user=true&count=50&screen_name=testTwitter",
                     :content_type => "application/json",
                     :body => json_fixture('twitter/tweets.json', :twitter_uid => account.uid))

        ApplicationController.any_instance.stub(:current_twitter_account).and_return(account)

        get campaign_path(campaign)
        last_response.status.should==200

        get new_campaign_twitter_status_path(campaign)
        last_response.status.should==200

        tweet = <<-TWEET
{
    "created_at": "Sat Nov 17 16:42:53 +0000 2012",
    "id": 269843058630205440,
    "id_str": "269843058630205440",
    "text": "RT @kyleshank: Donate Your Account statement http://t.co/Aj2CG2Zt",
    "truncated": false,
    "in_reply_to_status_id": null,
    "in_reply_to_status_id_str": null,
    "in_reply_to_user_id": null,
    "in_reply_to_user_id_str": null,
    "in_reply_to_screen_name": null,
    "user": {
      "id": #{account.uid},
      "id_str": "#{account.uid}"
    },
    "geo": null,
    "coordinates": null,
    "place": null,
    "contributors": null
}
TWEET

        FakeWeb.register_uri(:get, "https://api.twitter.com/1.1/statuses/show/269843058630205440.json",
                     :content_type => "application/json",
                     :body => tweet)

        FakeWeb.register_uri(:post, "https://api.twitter.com/1.1/statuses/retweet/269843058630205440.json",
                    [
                        {:content_type => "application/json", :body => "", :status => ["403", "Forbidden"]}
                    ]
                    )

        post campaign_twitter_statuses_path(campaign), {twitter_status: {"uid" => 269843058630205440, "levels" => ["2"]}}
        last_response.status.should==302
        last_response.headers["Location"].should match /^http\:\/\/.+\/test$/
        follow_redirect!

        last_response.status.should==200
        campaign.twitter_statuses.count.should==1

        campaign.twitter_statuses.first.publish

        campaign.twitter_statuses.first.donated_statuses.count.should==0
    end
end