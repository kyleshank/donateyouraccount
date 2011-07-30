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
class Campaign < ActiveRecord::Base
  belongs_to :account
end

class CampaignUpdate < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :permalink, :string
    Account.reset_column_information
    Campaign.reset_column_information
    Campaign.all.each do |c|
        c.update_attribute(:permalink, c.account.screen_name)
    end
    rename_column :campaigns, :account_id, :twitter_account_id
    add_column :campaigns, :facebook_account_id, :integer
    add_column :campaigns, :facebook_page_uid, :string
  end

  def self.down
    remove_column :campaigns, :permalink, :string
    rename_column :campaigns, :twitter_account_id, :account_id
    remove_column :campaigns, :facebook_account_id
    remove_column :campaigns, :facebook_page_uid
  end
end
