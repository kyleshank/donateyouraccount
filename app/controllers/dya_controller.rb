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
class DyaController < ApplicationController
  before_filter :login_required, :only => [:home]
  
  before_filter :redirect_if_campaign_domain, :except => [:signout]

  def index
    redirect_to dashboard_path and return if logged_in?
    @donations = Donation.select("DISTINCT(campaign_id)").order("id DESC").limit(4)
  end

  def home
    @donated_statuses = Status.donated_through_account(current_accounts).desc.paginate(:page => params[:page], :per_page=>10)
  end

  def start
    render :layout => false
  end

  def signout
    @current_twitter_account = @current_facebook_account = nil
    session.delete(:current_twitter_account)
    session.delete(:current_facebook_account)
    redirect_to "/"
  end
end