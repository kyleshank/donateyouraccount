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
class Status < ActiveRecord::Base
  belongs_to :campaign
  has_many :donated_statuses
  has_many :donations, :through => :donated_statuses

  validates_presence_of :campaign, :body
  validates_length_of :body, :maximum=>140, :minimum => 1

  scope :donated_through_account, lambda {|a| {:joins => "INNER JOIN donated_statuses ON donated_statuses.status_id = statuses.id INNER JOIN donations ON donations.id = donated_statuses.donation_id INNER JOIN accounts ON donations.account_id = accounts.id ", :conditions => ["accounts.id = ?", a.id], :group => "statuses.id" } }  
  scope :desc, order("statuses.id desc")
  scope :within_1_day, :conditions => "statuses.created_at > (NOW()-#{1.day.to_i})"
  scope :within_1_week, :conditions => "statuses.created_at > (NOW()-#{7.day.to_i})"
  scope :within_1_month, :conditions => "statuses.created_at > (NOW()-#{28.day.to_i})"
  scope :for_levels, lambda {|levels| {:conditions => levels.collect{|l| "statuses.level = #{l}"}.join(" OR ")}}

  attr_accessor :levels

  before_create do
    tweet = Twitter::Client.new(:oauth_token => self.campaign.account.token, :oauth_token_secret => self.campaign.account.secret)
    response = tweet.update(self.body)
    self.twitter_status_id = response["id"]
  end

  after_create do
    self.delay.publish
  end

  def publish
    unless self.twitter_status_id.blank?
      level_array = []
      level_array << Donation::LEVELS["Gold"] if ((self.level & Donation::LEVELS["Gold"]) > 0)
      level_array << Donation::LEVELS["Silver"] if ((self.level & Donation::LEVELS["Silver"]) > 0)
      level_array << Donation::LEVELS["Bronze"] if ((self.level & Donation::LEVELS["Bronze"]) > 0)
      self.campaign.donations.for_levels(level_array).each do |donation|
        donation.donated_statuses.create(:status => self)
      end
    end
  end

  def validate
    accumulator = 0
    if self.levels.is_a?(Array)
      self.levels.each do |l|
        accumulator += l.to_i
      end
    end
    self.level = accumulator
    if (self.level & Donation::LEVELS["Gold"]) > 0
      errors.add(:level, "Gold level donation has already been utilized") if (self.campaign.statuses.for_levels(4..7).within_1_day.count > 0)
    end
    if (self.level & Donation::LEVELS["Silver"]) > 0
      errors.add(:level, "Silver level donation has already been utilized") if (self.campaign.statuses.for_levels([2,3,6,7]).within_1_week.count > 0)
    end
    if (self.level & Donation::LEVELS["Bronze"]) > 0
      errors.add(:level, "Bronze level donation has already been utilized") if (self.campaign.statuses.for_levels([1,3,5,7]).within_1_month.count > 0)
    end
    if accumulator == 0
      errors.add(:level, "at least one must be selected")
    end
  end

  def twitter_permalink
    "http://twitter.com/#{self.campaign.account.screen_name}/statuses/#{self.twitter_status_id}"
  end
end
