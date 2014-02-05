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

describe Donation do
	def app
  	Dya::Application
	end

	it "should donate and un-donate a Facebook account" do
		account = create(:facebook_account, uid: "123456")
		campaign_account = create(:facebook_account, uid: "6789")
		page = <<-EOS
{
  "name": "Donate Your Account", 
  "access_token": "testToken", 
  "category": "Community", 
  "id": "234324", 
  "perms": [
    "ADMINISTER", 
    "EDIT_PROFILE", 
    "CREATE_CONTENT", 
    "MODERATE_CONTENT", 
    "CREATE_ADS", 
    "BASIC_ADMIN"
  ]
}
EOS
		campaign = create(:campaign, facebook_account_id: campaign_account.id, permalink: "test", facebook_page: page)

		ApplicationController.any_instance.stub(:current_facebook_account).and_return(account)

		get campaign_path(campaign)
		last_response.status.should==200

		get facebook_campaign_donations_path(campaign)
		last_response.status.should==200

		post facebook_campaign_donations_path(campaign), {donation: {level: Donation::LEVELS["Silver"]}}
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