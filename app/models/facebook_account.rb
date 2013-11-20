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
    graph = OAuth2::AccessToken.new(get_oauth_client, self.token, :refresh_token=>self.refresh_token)
    JSON.parse(graph.get(uri, opts).body)
  end

  def post(uri, opts = {})
    graph = OAuth2::AccessToken.new(get_oauth_client, self.token, :refresh_token=>self.refresh_token)
    JSON.parse(graph.post(uri, opts).body)
  end

  def url
    "http://facebook.com/profile.php?id=#{self.uid}"
  end

  def recent_links(_id)
    get("/#{_id}/links")["data"].select {|item| !item["link"].blank? }
  end

  def share(_data)
    d = _data.dup
    d.delete("actions")
    d.delete("created_time")
    d.delete("updated_time")
    d.delete("privacy")
    d.delete("id")
    from = d.delete("from")
    if from
      message = "via #{from["name"]}:"
      unless d["message"].empty?
        message = "#{message}\n\n#{d["message"]}"
      end
      d["message"] = message
    end
    try_to do
      begin
        post("/me/links", {:body => d})
      rescue OAuth2::Error => e
        self.expires_at=Time.now
        self.save
        raise StopRetryingException.new(e)
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

  def active!
    graph = OAuth2::AccessToken.new(get_oauth_client, self.token, :refresh_token=>self.refresh_token)
    graph.get("/me")
    long_lived_token_response = get_oauth_client.request(:get, "/oauth/access_token", :params => {:client_id => FACEBOOK_APPLICATION_ID, :client_secret => FACEBOOK_APPLICATION_SECRET, :grant_type => "fb_exchange_token", :fb_exchange_token => self.token})
    long_lived_token = Rack::Utils.parse_nested_query(long_lived_token_response.body)
    self.token = long_lived_token["access_token"]
    self.expires_at = Time.now.utc + long_lived_token["expires"].to_i if long_lived_token["expires"]
    self.save
  rescue Exception
    self.expires_at=Time.now
    self.save
  end

  def notify!
    campaigns = self.donations.collect{|d| d.campaign}
    unless campaigns.empty?
      graph = OAuth2::AccessToken.new(get_oauth_client, FACEBOOK_APPLICATION_TOKEN)
      graph.post("/#{self.uid}/notifications?href=#{CGI.escape("facebook_accounts/new")}&template=#{CGI.escape("Click here to continue donating to #{campaigns.collect{|c| c.name}.join(', ')}")}.")
    end
  end

  def self.notify!
    FacebookAccount.where(["(expires_at > NOW()) AND (expires_at < ?)", Time.now+(86400*7)]).each do |account|
      account.notify!
    end
  end
end