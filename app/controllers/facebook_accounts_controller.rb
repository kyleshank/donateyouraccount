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

  def new
    redirect_to get_oauth_client.web_server.authorize_url(
      :redirect_uri => facebook_redirect_uri,
      :scope => 'offline_access,share_item'
    )
  end

  def create
   begin
      access_token = get_oauth_client.web_server.get_access_token(params[:code], :redirect_uri => facebook_redirect_uri)
      response = access_token.get('/me')
      user_info = JSON.parse(response)

      @account = FacebookAccount.where(:uid => user_info["id"]).first

      unless @account
        @account = FacebookAccount.new(
            :uid => user_info["id"]
        )
      end

      @account.name = "#{user_info["first_name"]} #{user_info["last_name"]}"
      @account.screen_name = user_info["username"]
      @account.token = params[:code]
      @account.followers = JSON.parse(access_token.get("/me/friends"))["data"].size
      @account.facebook_pages = JSON.parse(access_token.get("/me/accounts"))["data"].select{|a| a["category"] != "Application"}.to_json

      if @account.save
        self.current_facebook_account=@account
      end

      redirect_back_or_default dashboard_path
    rescue Exception
      flash[:notice] = "Facebook error"
      redirect_to "/"
    end
  end

  private

  def facebook_redirect_uri
    "http://#{request.host_with_port}/facebook_accounts/oauth_create"
  end
end