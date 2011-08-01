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
class TwitterAccount < Account
  include RetryHelper
  
  validates_presence_of :screen_name, :secret

  def profile_image_url
    self["profile_image_url"] || "http://a0.twimg.com/a/1294084247/images/default_profile_4_normal.png"
  end

  def url
  "http://twitter.com/#{self.screen_name}"
  end

  def twitter_url
    url
  end

  def recent_tweets
    try_to do
      Twitter::Client.new(:oauth_token => self.token, :oauth_token_secret => self.secret).user_timeline(self.screen_name, :trim_user => true, :count => 50)
    end
  end

  def retweet(_id)
    try_to do
      begin
        Twitter::Client.new(:oauth_token => self.token, :oauth_token_secret => self.secret).retweet(_id)
      rescue Twitter::Unauthorized
        # EAT IT
      end
    end
  end
end