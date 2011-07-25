class FacebookStatusesController < ApplicationController

  before_filter :login_required
  before_filter :ensure_campaign

  def new
    @facebook_status = @campaign.facebook_statuses.new
  end

  def create
    @facebook_status = @campaign.facebook_statuses.new(params[:facebook_status])

    if @facebook_status.save
      flash[:notice] = "Publishing to Facebook"
      redirect_to campaign_permalink_path(@campaign) and return
    end

    redirect_to dashboard_path
  end

  private

  def ensure_campaign
    @campaign = Campaign.where(:permalink => params[:campaign_id]).first
    redirect_to new_campaign_path and return false unless @campaign
    redirect_to campaign_path(@campaign) and return false unless @campaign.facebook_account
  end

end