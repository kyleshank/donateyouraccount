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
module AccountsHelper
  def get_twitter_request_token
    get_request_token(Twitter.consumer_key,
                      Twitter.consumer_secret,
                      "http://twitter.com",
                      "http://#{request.host_with_port}/accounts/oauth_create")
  end

  private

  def get_request_token consumer_key, consumer_secret, site, return_url
    consumer = OAuth::Consumer.new(consumer_key, consumer_secret, { :site => site })
    request_token = consumer.get_request_token(:oauth_callback => return_url)

    session[:request_token] = request_token.token
    session[:request_token_secret] = request_token.secret
    request_token
  end
end
