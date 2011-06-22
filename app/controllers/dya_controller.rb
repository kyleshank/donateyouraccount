class DyaController < ApplicationController
  def index
    redirect_to dashboard_path and return if current_account
    @donations = Donation.select("DISTINCT(campaign_id)").order("id DESC").limit(4)
    render :layout => false
  end

  def signout
    @current_account = nil
    session.delete(:current_account)
    redirect_to "/"
  end
end