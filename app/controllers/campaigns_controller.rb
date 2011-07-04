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
class CampaignsController < ApplicationController
  include AccountsHelper
  
  before_filter :login_required, :except => [:show]
  before_filter :new_campaign, :only =>[:new,:create]
  before_filter :load_campaign, :only =>[:edit,:update, :destroy]

  def new

  end

  def create
    @campaign.account = current_account
    if @campaign.save
      flash[:notice] = "Campaign created"
      redirect_to campaign_permalink_path(@campaign) and return
    end
  end

  def edit
  end

  def update
    if @campaign.update_attributes(params[:campaign])
      flash[:notice] = "Campaign updated"
      redirect_to campaign_permalink_path(@campaign) and return
    end
    render :action => :edit
  end

  def show
    @account = Account.first(:conditions => {:screen_name => params[:id]})

    render_not_found and return unless @account and @account.campaign

    @campaign = @account.campaign
    @statuses = @campaign.statuses.desc.paginate(:page => params[:page], :per_page=>10)
    @donation = current_account.donations.for_campaign(@campaign.id).first if current_account

    respond_to do |format|
      format.html{}
      format.js {@donors = @campaign.donations.desc.limit(14).all}
    end
  end

  def destroy
    @campaign.destroy
    flash[:notice] = "Campaign destroyed"
    redirect_to dashboard_path
  end

  private

  def new_campaign
    redirect_to campaign_permalink_path(current_account.campaign) if current_account.campaign
    @campaign = Campaign.new(params[:campaign])
  end

  def load_campaign
    @campaign = current_account.campaign
    render_not_found and return unless @campaign
  end
end