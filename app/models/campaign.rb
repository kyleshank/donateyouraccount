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
  validates_exclusion_of :permalink, :in => %w(account accounts signin signout home facebook_accounts twitter_accounts campaign campaigns dya)
  validates_format_of :permalink, :with => /^[a-zA-Z0-9_]*[a-zA-Z][a-zA-Z0-9_]*$/

  validate :validate_campaign

  def validate_campaign
    if self.twitter_account.nil? and self.facebook_account.nil?
      errors.add(:twitter_account, "at least 1 account must be associated with a Campaign")
      errors.add(:facebook_account, "at least 1 account must be associated with a Campaign")
    else
      errors.add(:twitter_account, "Twitter account can't be changed once donations have been made'") if self.changed.include?("twitter_account_id") and (self.donations.twitter.count > 0)
      errors.add(:facebook_page_uid, "Facebook page can't be changed once donations have been made") if self.changed.include?("facebook_page_uid") and (self.donations.facebook.count > 0)
    end
  end

  scope :desc, :order => "campaigns.id desc"
  scope :suggest_for, lambda {|aid| {:select => "DISTINCT(campaigns.id),campaigns.*", :joins => "LEFT JOIN donations ON donations.campaign_id = campaigns.id", :conditions => ["donations.account_id != ? AND campaigns.account_id != ?", aid, aid]}}
  scope :for_accounts, lambda {|accounts| { :conditions => conditions_for_accounts(accounts)}}

  def self.conditions_for_accounts(accounts)
    conds = []
    accounts.each do |a|
      if a.is_a?(TwitterAccount)
      conds << "campaigns.#{a.class.name.underscore}_id=#{a.id}"
      elsif a.is_a?(FacebookAccount)
        a.facebook_pages.each do |p|
          conds << "campaigns.facebook_page_uid=#{p['id']}"
        end
      end
    end
    conds.join(" OR ")
  end

  def to_param
    self.permalink
  end

  def image
    return self.twitter_account.profile_image_url if self.twitter_account && !self.twitter_account.profile_image_url.blank?
    return self.facebook_page["picture"] if self.facebook_page
    "/images/default_campaign.png"
  end

  def facebook_page
    self["facebook_page"].blank? ? nil : JSON.parse(self["facebook_page"])
  end
end
