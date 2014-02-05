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
class FacebookStatusesController < ApplicationController

  before_filter :login_required
  before_filter :ensure_campaign

  skip_before_filter :redirect_if_campaign_domain, :only => [:new]
  before_filter :redirect_to_dya_if_campaign_domain, :only => [:new]

  def new
    @facebook_status = @campaign.facebook_statuses.new
  end

  def create
    @facebook_status = @campaign.facebook_statuses.new(status_params)
    @facebook_status.levels = params[:facebook_status][:levels]

    if @facebook_status.save
      flash[:notice] = "Publishing to Facebook"
      redirect_to campaign_permalink_path(@campaign) and return
    else
      @model =@facebook_status
      render :action => :new
    end
  end

  private

  def status_params
    params.require(:facebook_status).permit(:uid)
  end

  def ensure_campaign
    @campaign = Campaign.where(:permalink => params[:campaign_id]).first
    redirect_to new_campaign_path and return false unless @campaign
    redirect_to campaign_path(@campaign) and return false unless @campaign.facebook_page_uid
    render_access_denied unless (current_facebook_account and @campaign.facebook_page_uid and (@campaign.facebook_account_id==current_facebook_account.id) and current_facebook_account.facebook_page?(@campaign.facebook_page_uid))
  end

end