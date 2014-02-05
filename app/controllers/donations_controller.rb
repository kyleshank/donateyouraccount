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
class DonationsController < ApplicationController
  include TwitterAccountsHelper
  include FacebookAccountsHelper
  
  before_filter :load_campaign
  before_filter :twitter_required, :only => [:twitter, :twitter_create]
  before_filter :facebook_required, :only => [:facebook, :facebook_create]
  before_filter :login_required, :only => [:destroy]

  skip_before_filter :redirect_if_campaign_domain

  def twitter
    @donation = @campaign.donations.new
    @donation.level = Donation::LEVELS["Gold"]
  end

  def twitter_create
    @donation = @campaign.donations.new(donation_params)
    @donation.account = current_twitter_account
    if @donation.save
      expire_page("/#{@campaign.permalink}.js")
      redirect_to campaign_permalink_path(@campaign)
    else
      render :action => :twitter
    end
  end

  def facebook
    @donation = @campaign.donations.new
    @donation.level = Donation::LEVELS["Gold"]
  end

  def facebook_create
    @donation = @campaign.donations.new(donation_params)
    @donation.account = current_facebook_account
    if @donation.save
      expire_page("/#{@campaign.permalink}.js")
      redirect_to campaign_permalink_path(@campaign)
    else
      render :action => :facebook
    end
  end

  def destroy
    @donation = @campaign.donations.find(params[:id])
    render_not_found and return unless @donation

    if @donation.account.is_a?(TwitterAccount)
      unless current_twitter_account and (current_twitter_account.id==@donation.account.id)
        render_not_found and return
      end
    elsif @donation.account.is_a?(FacebookAccount)
      unless current_facebook_account and (current_facebook_account.id==@donation.account.id)
        render_not_found and return
      end
    end

    if @donation
      flash[:notice] = "Donation destroyed"
      @donation.destroy
    end

    redirect_to campaign_permalink_path(@campaign)
  end

  def delete
    @donation = @campaign.donations.find(params[:id])
    render_not_found and return unless @donation

    if @donation.account.is_a?(TwitterAccount)
      unless current_twitter_account and (current_twitter_account.id==@donation.account.id)
        render_not_found and return
      end
    elsif @donation.account.is_a?(FacebookAccount)
      unless current_facebook_account and (current_facebook_account.id==@donation.account.id)
        render_not_found and return
      end
    end
  end

  private

  def donation_params
    params.require(:donation).permit(:level)
  end

  def load_campaign
    @campaign = Campaign.where(:permalink => params[:campaign_id]).first
    render_not_found and return unless @campaign
  end

  def twitter_required
    unless current_twitter_account
      session[:return_to] = twitter_campaign_donations_path(@campaign)
      redirect_to get_twitter_request_token.authorize_url.gsub("authorize","authenticate") and return
    end
    redirect_to campaign_path(@campaign) and return if @campaign.twitter_account.id == current_twitter_account.id
    redirect_to campaign_path(@campaign) if current_twitter_account.donations.where(:campaign_id => @campaign.id).count > 0
  end

  def facebook_required
    unless current_facebook_account
      session[:return_to] = "#{request.protocol.downcase}#{request.host_with_port}#{facebook_campaign_donations_path(@campaign)}"
      redirect_to new_facebook_account_path
      return
    end
    redirect_to campaign_path(@campaign) if current_facebook_account.donations.where(:campaign_id => @campaign.id).count > 0
  end

end