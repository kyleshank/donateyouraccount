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