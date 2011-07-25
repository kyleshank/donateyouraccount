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
  has_many :donations
  has_many :statuses
  has_many :twitter_statuses
  belongs_to :twitter_account
  has_many :facebook_statuses
  belongs_to :facebook_account

  validates_presence_of :name, :description, :permalink
  validates_uniqueness_of :permalink

  scope :desc, :order => "campaigns.id desc"
  scope :suggest_for, lambda {|aid| {:select => "DISTINCT(campaigns.id),campaigns.*", :joins => "LEFT JOIN donations ON donations.campaign_id = campaigns.id", :conditions => ["donations.account_id != ? AND campaigns.account_id != ?", aid, aid]}}
  scope :for_accounts, lambda {|accounts| {:conditions => accounts.collect{|a| "campaigns.#{a.class.name.underscore}_id=#{a.id}"}.join(" OR ")} }

  def to_param
    self.permalink
  end

  def image
    self["image"] || ""
  end
end
