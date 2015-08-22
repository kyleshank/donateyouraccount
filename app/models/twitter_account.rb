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
      get_twitter_client.user_timeline(self.screen_name, :trim_user => true, :count => 50)
    end
  end

  def retweet(_id)
    try_to do
      begin
        get_twitter_client.retweet(_id)
      rescue Twitter::Error::Forbidden => e
        self.expiration_reason = "#{e.message}\n#{e.backtrace.join("\n")}"
        self.expires_at = Time.now
        self.save
        raise StopRetryingException.new(e)
      rescue Twitter::Error::Unauthorized => e
        self.expiration_reason = "#{e.message}\n#{e.backtrace.join("\n")}"
        self.expires_at = Time.now
        self.save
        raise StopRetryingException.new(e)
      end
    end
  end

  def get_twitter_client
      Twitter::REST::Client.new do |config|
        config.consumer_key        = TWITTER_CONSUMER_KEY
        config.consumer_secret     = TWITTER_CONSUMER_SECRET
        config.access_token        = self.token
        config.access_token_secret = self.secret
      end
  end
end