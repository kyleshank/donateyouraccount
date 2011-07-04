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
class DonatedStatus < ActiveRecord::Base
  belongs_to :donation
  belongs_to :status
  
  validates_presence_of :donation, :status

  validates_uniqueness_of :status_id, :scope => [:donation_id]

  after_create :retweet

  private

  def retweet
    retries = 0
    while retries < 5
      begin
        client = Twitter::Client.new(:oauth_token => self.donation.account.token, :oauth_token_secret => self.donation.account.secret)
        client.retweet(self.status.twitter_status_id)
        break
      rescue Exception
        retries += 1
      end
    end
  end
end
