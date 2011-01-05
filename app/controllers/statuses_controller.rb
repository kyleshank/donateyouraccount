class StatusesController < ApplicationController

  before_filter :login_required

  def create
    @status = current_account.statuses.new(params[:status])

    if @status.save
      request.flash.now["notice"] = "Status publishing to Twitter"
    end

    redirect_to account_permalink_path(current_account)
  end

end
