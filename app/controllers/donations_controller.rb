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
  include AccountsHelper
  
  before_filter :login_required, :except => [:new]
  before_filter :load_campaign

  def new
    if current_account
      @donation = @campaign.donations.new
      @donation.level = Donation::LEVELS["Silver"]
    else
      session[:return_to] = campaign_permalink_path(@campaign)
      session[:return_flash] = "Thanks for signing in! Click Donate below to continue"
      redirect_to get_twitter_request_token.authorize_url.gsub("authorize","authenticate")
    end
  end

  def create
    @donation = current_account.donations.new(params[:donation])
    @donation.campaign = @campaign
    if @donation.save
      flash[:notice] = "Donation made to #{@donation.campaign.account.screen_name}"
      redirect_to campaign_permalink_path(@campaign)
    else
      flash[:notice] = "There was an error donating to #{@donation.campaign.account.screen_name}"
      render :action => :new
    end
  end

  def destroy
    @donation = current_account.donations.for_campaign(@campaign.id).first

    if @donation
      flash[:notice] = "Donation destroyed"
      @donation.destroy
    end

    redirect_to campaign_permalink_path(@campaign)
  end

  private

  def load_campaign
    @account = Account.first(:conditions => {:screen_name => params[:id]})
    render_not_found and return unless @account and @account.campaign
    @campaign = @account.campaign
  end

end