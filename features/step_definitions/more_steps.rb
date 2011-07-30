##
# Donate Your Account (donateyouraccount.com)
# Copyright (C) 2011  Kyle Shank (kyle.shank@gmail.com)
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
Given /^I sign in as Twitter account "([^"]*)"$/ do |name|
  account = TwitterAccount.where(:name => name).first
  unless account
    account = double("TwitterAccount")
    account.stub(:uid){ (1 + rand(100000)).to_s }
    account.stub(:name){name}
    account.stub(:screen_name){ name }
  end
  response = double("Net::HTTPSuccess")
  response.stub(:code) { "200" }
  response.stub(:body) do
    {"id" => account.uid.to_i, "id_str" => account.uid, "name" => account.name, "screen_name" => account.screen_name, "is_translator"=>false, "verified"=>false, "profile_background_color"=>"404040", "lang"=>"en", "profile_background_image_url"=>"http://a0.twimg.com/profile_background_images/174082691/logo.png", "created_at"=>"Fri Nov 07 17:35:57 +0000 2008", "description"=>"building things.", "status"=>{"in_reply_to_user_id_str"=>"25037666", "text"=>"@greggiacovelli oh god greg! stackoverflow is like the SE lab.", "coordinates"=>nil, "retweeted"=>false, "retweet_count"=>0, "created_at"=>"Mon Jan 17 19:44:03 +0000 2011", "in_reply_to_user_id"=>25037666, "place"=>nil, "source"=>"<a href=\"http://itunes.apple.com/us/app/twitter/id409789998?mt=12\" rel=\"nofollow\">Twitter for Mac</a>", "in_reply_to_status_id"=>27088609634947072, "truncated"=>false, "favorited"=>false, "in_reply_to_status_id_str"=>"27088609634947072", "id_str"=>"27088783446908928", "geo"=>nil, "id"=>27088783446908928, "contributors"=>nil, "in_reply_to_screen_name"=>"greggiacovelli"}, "show_all_inline_media"=>true, "geo_enabled"=>true, "friends_count"=>168, "url"=>"http://kyleshank.com", "follow_request_sent"=>false, "profile_text_color"=>"333333", "followers_count"=>180, "following"=>false, "favourites_count"=>0, "profile_sidebar_fill_color"=>"5c5c5c", "location"=>"United States of America", "profile_background_tile"=>false, "time_zone"=>"Eastern Time (US & Canada)", "listed_count"=>9, "statuses_count"=>1641, "profile_link_color"=>"f89924", "protected"=>false, "profile_sidebar_border_color"=>"474747", "contributors_enabled"=>false, "notifications"=>false, "profile_use_background_image"=>true, "utc_offset"=>-18000, "profile_image_url"=>"http://a2.twimg.com/profile_images/799270743/profile_photo_cropped_normal.png"}.to_json
  end
  consumer = double("OAuth::Consumer")
  consumer.stub(:request) {response}
  access_token = double("OAuth::AccessToken")
  access_token.stub(:token) {"token"}
  access_token.stub(:secret) {"secret"}
  request_token = double("OAuth::RequestToken")
  request_token.stub(:get_access_token) {access_token}

  OAuth::Consumer.should_receive(:new).any_number_of_times.and_return(consumer)
  OAuth::RequestToken.should_receive(:new).any_number_of_times.and_return(request_token)
  visit("/twitter_accounts/oauth_create?oauth_verifier=test")
end

Given /^I sign in as Facebook account "([^"]*)"$/ do |name|
  account = FacebookAccount.where(:name => name).first
  unless account
    account = double("FacebookAccount")
    account.stub(:uid){(1 + rand(100000)).to_s}
    account.stub(:name){ name }
    account.stub(:token){"token"}
  end
  access_token = double("OAuth2::AccessToken")
  access_token.stub(:get) do |arg|
    case arg
      when "/me"
        {"id"=>account.uid, "name"=>account.name, "first_name"=>name.split("\s+")[0], "last_name"=>name.split("\s+")[1], "link"=>"http://www.facebook.com/test", "location"=>{"id"=>"", "name"=>nil}, "gender"=>"male", "timezone"=>-5, "locale"=>"en_US", "verified"=>true, "updated_time"=>"2010-08-11T14:25:24+0000"}.to_json
      when "/me/accounts"
        {"data"=>[{"name"=>"Donate Your Account", "category"=>"Website", "id"=>"128107323942962"}, {"name"=>"Reactualize", "category"=>"Product/service", "id"=>"104955406227901"}, {"name"=>"Donate Your Account", "category"=>"Application", "id"=>"114902775246811"}, {"name"=>"Donate Your Account Staging", "category"=>"Application", "id"=>"145481695503129"}, {"category"=>"Application", "id"=>"143681932313719"}, {"category"=>"Application", "id"=>"121454094533824"}, {"category"=>"Application", "id"=>"112835425422620"}, {"category"=>"Application", "id"=>"178035084190"}]}.to_json
      when "/me/friends"
        {"data" => [{"name" => "My Friend 1", "id" => "12345"}, {"name" => "My Friend 2", "id" => "123456"}]}.to_json
      when "/128107323942962"
        {"id" => "128107323942962","name" => "Donate Your Account","picture" => "http://profile.ak.fbcdn.net/hprofile-ak-snc4/211112_128107323942962_3822781_s.jpg","link" => "http://www.facebook.com/pages/Donate-Your-Account/128107323942962","likes" => 1,"category" => "Website","website" => "http://donateyouraccount.com","founded" => "2011","description" => "A website that allows you to donate your Facebook or Twitter account to campaigns you support.","can_post" => true,"type" => "page"}.to_json
    end
  end

  webserver = double()
  webserver.stub(:get_access_token){access_token}

  oauth_client = double("OAuth2::Client")
  oauth_client.stub(:web_server){webserver}

  OAuth2::Client.should_receive(:new).any_number_of_times.and_return(oauth_client)
  visit("/facebook_accounts/oauth_create?code=test")
end

When /^(?:|I )click "([^"]*)"(?: within "([^"]*)")?$/ do |link, selector|
  with_scope(selector) do
    click_link(link)
  end
end

Given /^there is a campaign "([^"]*)"$/ do |name|
  f = Factory.create(:facebook_account, :name => "facebook_#{name}", :uid => 1000)
  t = Factory.create(:twitter_account, :screen_name => "twitter_#{name}", :name => "twitter_#{name}", :uid => 1001)
  Factory.create(:campaign, :name => name, :permalink => name.strip.underscore, :twitter_account => t, :facebook_account => f, :facebook_page_uid => "3209445334")
end

Given /^there is a Twitter campaign "([^"]*)"$/ do |name|
  t = Factory.create(:twitter_account, :screen_name => "twitter_#{name}", :name => "twitter_#{name}", :uid => 1001)
  Factory.create(:campaign, :name => name, :permalink => name.strip.underscore, :twitter_account => t)
end

Given /^there is a Facebook campaign "([^"]*)"$/ do |name|
  f = Factory.create(:facebook_account, :name => "facebook_#{name}", :uid => 1000)
  Factory.create(:campaign, :name => name, :permalink => name.strip.underscore, :facebook_account => f, :facebook_page_uid => "3209445334")
end

Given /^there is a Twitter account "([^"]*)"$/ do |screen_name|
  Factory.create(:twitter_account, :screen_name => screen_name, :name => screen_name, :uid => 1)
end

Given /^there is a Facebook account "([^"]*)"$/ do |name|
  Factory.create(:facebook_account, :name => name, :uid => 2)
end

When /^I accept the confirmation dialog$/ do
  page.evaluate_script("window.confirm = function() { return true; }")
end