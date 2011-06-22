class DyaController < ApplicationController
  def index
    redirect_to dashboard_path and return if current_account
    @donations = Donation.select("DISTINCT(donations.campaign_id)").order("donations.id DESC").where("donations.campaign_id IS NOT NULL").joins(:campaign).limit(4)
    render :layout => false
  end

  def signout
    @current_account = nil
    session.delete(:current_account)
    redirect_to "/"
  end
end