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
class FacebookAccount < Account
  include FacebookAccountsHelper
  include RetryHelper

  attr_accessor :profile_image_url

  def get(uri, opts = {})
    try_to do
      graph = OAuth2::AccessToken.new(get_oauth_client, self.token, :refresh_token=>self.refresh_token)
      JSON.parse(graph.get(uri, opts).body)
    end
  end

  def post(uri, opts = {})
    try_to do
      graph = OAuth2::AccessToken.new(get_oauth_client, self.token, :refresh_token=>self.refresh_token)
      JSON.parse(graph.post(uri, opts).body)
    end
  end

  def url
    "http://facebook.com/profile.php?id=#{self.uid}"
  end

  def recent_links(_id)
    get("/#{_id}/feed")["data"].select {|item| !item["link"].blank? }
  end

  def share(_data)
    d = _data.dup
    d.delete("from")
    d.delete("actions")
    d.delete("created_time")
    d.delete("updated_time")
    d.delete("privacy")
    d.delete("message")
    d.delete("id")
    try_to do
      begin
        post("/me/links", {:body => d})
      rescue OAuth2::Error
        # NOOP
      end
    end
  end

  def facebook_pages
    self["facebook_pages"].blank? ? [] : JSON.parse(self["facebook_pages"])
  end

  def facebook_page?(id)
    facebook_pages.collect{|p| p["id"]}.include?(id)
  end

  def profile_image_url
    "http://graph.facebook.com/#{self.uid}/picture"
  end
end