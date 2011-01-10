class StatusesController < ApplicationController

  before_filter :login_required

  def create
    redirect_to :back and return unless current_account.campaign
    
    @status = current_account.campaign.statuses.new(params[:status])

    if @status.save
      request.flash.now["notice"] = "Status publishing to Twitter"
    end

    redirect_to campaign_permalink_path(current_account.campaign)
  end

end
