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
class CampaignName < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :name, :string
    add_column :campaigns, :image, :string
    Campaign.reset_column_information
    TwitterAccount.all.each do |t|
      c = Campaign.where(:twitter_account_id => t.id).first
      c.update_attributes({:name => t.name, :image => t.profile_image_url}) if c
    end
  end

  def self.down
    remove_column :campaigns, :name
    remove_column :campaigns, :image
  end
end
