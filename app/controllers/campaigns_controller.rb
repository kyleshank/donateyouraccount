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
  include TwitterAccountsHelper
  
  before_filter :login_required, :except => [:show,:index]
  before_filter :load_campaign, :only =>[:edit,:update, :destroy, :upgrade, :downgrade]

  caches_page :show, :if => Proc.new { |c| c.request.format.js? }

  before_filter :redirect_to_dya_if_campaign_domain, :only => [:edit]
  before_filter :redirect_if_campaign_domain, :except => [:show]

  def index
    @donations = Donation.joins(:account).where("accounts.expires_at IS NULL or accounts.expires_at > NOW()").select("campaign_id, count(*) as total").includes(:campaign).group(:campaign_id).order("total desc")
  end

  def new
    @campaign = Campaign.new
    if current_facebook_account
      redirect_to new_facebook_account_path(:manage_pages => "true", :return_to => new_campaign_path) unless session[:manage_pages]=="true"
    end
    @campaign.twitter_account_id = current_twitter_account.id if current_twitter_account
    @campaign.permalink = current_twitter_account.screen_name if current_twitter_account
  end

  def create
    @campaign = Campaign.new(campaign_params)
    unless @campaign.facebook_page_uid.blank?
      @campaign.facebook_account = current_facebook_account
      current_facebook_account.facebook_pages.each do |p|
        @campaign.facebook_page = @campaign.facebook_account.get("/#{p["id"]}").to_json if p["id"] == @campaign.facebook_page_uid
      end
    end
    if @campaign.save
      flash[:notice] = "Campaign created"
      redirect_to campaign_permalink_path(@campaign)
    else
      render :action => :new
    end
  end

  def edit
    if current_facebook_account
      redirect_to new_facebook_account_path(:manage_pages => "true", :return_to => edit_campaign_path(@campaign)) unless session[:manage_pages]=="true"
    end
  end

  def update
    if campaign_params[:facebook_page_uid]
      if campaign_params[:facebook_page_uid].blank?
        @campaign.facebook_account=nil
        @campaign.facebook_page_uid=nil
        @campaign.facebook_page=nil
      else
        @campaign.facebook_account = current_facebook_account
        current_facebook_account.facebook_pages.each do |p|
          @campaign.facebook_page = @campaign.facebook_account.get("/#{p["id"]}").to_json if p["id"] == params[:campaign][:facebook_page_uid]
        end
      end
    end

    @campaign.levels = params[:levels]

    if @campaign.update_attributes(campaign_params)
      flash[:notice] = "Campaign updated"
      # redirect_to campaign_permalink_path(@campaign) and return
    end
    render :action => :edit
  end

  def show
    @campaign = Campaign.where(:permalink => params[:id]).first
    @campaign = @premium_campaign if @premium_campaign

    render_not_found and return unless @campaign

    unless @campaign.managed_by?(current_accounts)
      if @campaign.premium? and @campaign.domain and !@campaign.domain.empty? and (request.format!="js")
        if (request.host != @campaign.domain) or (request.path!="/")
          redirect_to "http://#{@campaign.domain}" and return
        end
      end
    end

    @statuses = @campaign.statuses.desc.paginate(:page => params[:page], :per_page=>10)
    @twitter_donation = current_twitter_account.donations.for_campaign(@campaign.id).first if current_twitter_account
    @facebook_donation = current_facebook_account.donations.for_campaign(@campaign.id).first if current_facebook_account

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

  def upgrade
    token = params[:stripeToken]
    @campaign.email = params[:campaign][:email]
    if @campaign.upgrade!(token)
      flash[:success] = "You've been upgraded to Donate Your Account Pro!"
    else
      flash[:error] = @campaign.errors.first[1]
    end

    redirect_to edit_campaign_path(@campaign)
  end

  def downgrade
    @campaign.downgrade!
    flash[:success] = "Your account has been downgraded back to the Free plan"
    redirect_to edit_campaign_path(@campaign)
  end

  private

  def campaign_params
    if @campaign and @campaign.premium?
      params.require(:campaign).permit(:name, :permalink, :twitter_account_id, :facebook_page_uid, :description, :domain, :css, :thank_you_title, :thank_you_body, :level_gold, :level_silver, :level_bronze, :email)
    else
      params.require(:campaign).permit(:name, :permalink, :twitter_account_id, :facebook_page_uid, :description)
    end
  end

  def load_campaign
    @campaign = Campaign.where(:permalink =>params[:id]).first
    render_not_found and return unless @campaign
    render_access_denied unless (current_twitter_account and @campaign.twitter_account and (@campaign.twitter_account.id == current_twitter_account.id)) or (current_facebook_account and @campaign.facebook_page_uid and current_facebook_account.facebook_page?(@campaign.facebook_page_uid))
  end
end