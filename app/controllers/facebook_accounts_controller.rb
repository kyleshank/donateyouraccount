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

class FacebookAccountsController < ApplicationController
  include FacebookAccountsHelper

  skip_before_filter :redirect_if_campaign_domain

  def new
    session[:return_to] = CGI.unescape(params[:return_to]) if params[:return_to]
    if @premium_campaign
      redirect_to "#{request.protocol}#{DYA_DOMAIN}#{request.path}?return_to=#{request.original_url}" 
      return
    end
    permissions = ["share_item"]
    if (params[:manage_pages]=="true") or (session[:manage_pages]=="true") or (cookies[:manage_pages]=="true")
      session[:manage_pages]="true"
      cookies[:manage_pages]="true"
      permissions << "manage_pages" 
    end
    redirect_to get_oauth_client.auth_code.authorize_url(
      :redirect_uri => facebook_redirect_uri,
      :scope => permissions.join(',')
    )
  end

  def create
    session[:return_to] = params[:return_to] if params[:return_to] and (session[:return_to].nil?)
    if session[:return_to]
      return_to_scheme = URI.parse(session[:return_to]).scheme
      return_to_host = URI.parse(session[:return_to]).host
      @premium_campaign = Campaign.where(domain: return_to_host).first if return_to_host
      if @premium_campaign and (@premium_campaign.domain != request.host)
        params[:return_to] = "http://#{return_to_host}"
        session.delete(:return_to)
        redirect_to "http://#{return_to_host}#{oauth_create_facebook_accounts_path(params)}"
        return
      end
    end
   begin
      short_lived_access_token = get_oauth_client.auth_code.get_token(params[:code], :redirect_uri => facebook_redirect_uri, :parsed => :facebook)

      long_lived_token_response = get_oauth_client.request(:get, "/oauth/access_token", :params => {:client_id => FACEBOOK_APPLICATION_ID, :client_secret => FACEBOOK_APPLICATION_SECRET, :grant_type => "fb_exchange_token", :fb_exchange_token => short_lived_access_token.token})
      long_lived_token = Rack::Utils.parse_nested_query(long_lived_token_response.body)

      access_token = OAuth2::AccessToken.new(get_oauth_client, long_lived_token["access_token"])

      response = access_token.get('/me')
      user_info = JSON.parse(response.body)

      @account = FacebookAccount.where(:uid => user_info["id"]).first

      unless @account
        @account = FacebookAccount.new(
            :uid => user_info["id"]
        )
      else
        notice = "Your Facebook donations have been refreshed"
        notice += " through #{Time.now.utc + long_lived_token["expires"].to_i}" if long_lived_token["expires"]
        flash[:notice] = notice
      end

      @account.name = "#{user_info["first_name"]} #{user_info["last_name"]}"
      @account.screen_name = user_info["username"]
      @account.token = access_token.token
      @account.refresh_token = access_token.refresh_token
      @account.followers = JSON.parse(access_token.get("/me/friends").body)["data"].size
      @account.facebook_pages = JSON.parse(access_token.get("/me/accounts").body)["data"].select{|a| a["category"] != "Application"}.to_json if session[:manage_pages]=="true"
      @account.expires_at = Time.now.utc + 60.days
      @account.expires_at = Time.now.utc + long_lived_token["expires"].to_i if long_lived_token["expires"]

      if @account.save
        self.current_facebook_account=@account
      end

      if Rails.env=="production"
        redirect_back_or_default("https://#{request.host_with_port}/")
      else
        redirect_back_or_default dashboard_path
      end
    rescue Exception => e
      p e
      flash[:notice] = "Facebook error"
      redirect_to "/"
    end
  end

  private

  def facebook_redirect_uri
    FACEBOOK_OAUTH_REDIRECT
  end
end