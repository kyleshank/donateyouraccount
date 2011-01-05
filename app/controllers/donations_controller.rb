class DonationsController < ApplicationController

  def index
    @donations = current_account.donations
  end

  def create
    @donation = Donation.new(params[:donation])
    @donation.account = current_account
    if @donation.save
      request.flash.now["notice"] = "Donation made to #{@donation.campaign.name}"
    else
      request.flash.now["notice"] = "There was an error donating to #{@donation.campaign.name}"
    end
    redirect_to account_permalink_path(@donation.campaign)
  end

  def destroy
    @donation = Donation.find(params[:id])
    if @donation.account_id == current_account.id
      @donation.destroy
    end
    redirect_to account_permalink_path(@donation.campaign)
  end

end