class StatusesController < ApplicationController

  before_filter :login_required

  def create
    redirect_to :back and return unless current_account.campaign
    
    @status = current_account.campaign.statuses.new(params[:status])

    begin
      if @status.save
        flash[:notice] = "Status publishing to Twitter"
        redirect_to campaign_permalink_path(current_account.campaign) and return
      end
    rescue Exception => e
      @status.errors.add(:body, e.message)
    end

    error_string = "<ul>"
      @status.errors.full_messages.each do |s|
        error_string += "<li>#{s}</li>"
      end
      error_string += "</ul>"
      flash[:notice] = error_string
      redirect_to dashboard_path
  end

end
