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