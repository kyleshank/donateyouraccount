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
class TwitterStatus < Status
  include RetryHelper

  validate :validate_levels

  before_create do |twitter_status|
    twitter_status.data = Twitter::Client.new(:oauth_token => self.campaign.twitter_account.token, :oauth_token_secret => self.campaign.twitter_account.secret).status(twitter_status.uid).to_json
  end

  def data
    return nil if self["data"].blank?
    JSON.parse(self["data"])
  end

  def permalink
    "http://twitter.com/#{self.campaign.twitter_account.screen_name}/statuses/#{self.uid}"
  end

  def publish
    level_array = []
    level_array << Donation::LEVELS["Gold"] if ((self.level & Donation::LEVELS["Gold"]) > 0)
    level_array << Donation::LEVELS["Silver"] if ((self.level & Donation::LEVELS["Silver"]) > 0)
    level_array << Donation::LEVELS["Bronze"] if ((self.level & Donation::LEVELS["Bronze"]) > 0)
    self.campaign.donations.twitter.for_levels(level_array).each do |donation|
      donation.donated_statuses.create(:status => self)
    end
  end

  def broadcast(donation)
    donation.account.retweet(self.uid)
  end

  private

  def validate_levels
    accumulator = 0
    if self.levels.is_a?(Array)
      self.levels.each do |l|
        accumulator += l.to_i
      end
    end
    self.level = accumulator
    if (self.level & Donation::LEVELS["Gold"]) > 0
      errors.add(:level, "Gold level donation has already been utilized") if (self.campaign.twitter_statuses.for_levels(4..7).within_1_day.count > 0)
    end
    if (self.level & Donation::LEVELS["Silver"]) > 0
      errors.add(:level, "Silver level donation has already been utilized") if (self.campaign.twitter_statuses.for_levels([2,3,6,7]).within_1_week.count > 0)
    end
    if (self.level & Donation::LEVELS["Bronze"]) > 0
      errors.add(:level, "Bronze level donation has already been utilized") if (self.campaign.twitter_statuses.for_levels([1,3,5,7]).within_1_month.count > 0)
    end
    if accumulator == 0
      errors.add(:level, "at least one must be selected")
    end
  end
end