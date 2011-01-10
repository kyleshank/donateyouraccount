class CampaignsController < ApplicationController
  include AccountsHelper
  
  before_filter :login_required, :except => [:show,:donate]
  before_filter :new_campaign, :only =>[:new,:create]
  before_filter :load_campaign, :only =>[:edit,:update]

  def new

  end

  def create
    @campaign.account = current_account
    if @campaign.save
      redirect_to campaign_permalink_path(@campaign) and return
    end
  end

  def edit
  end

  def update
    if @campaign.update_attributes(params[:campaign])
      redirect_to campaign_permalink_path(@campaign) and return
    end
    render :action => :edit
  end

  def show
    @account = Account.first(:conditions => {:screen_name => params[:id]})

    render_not_found and return unless @account and @account.campaign

    @campaign = @account.campaign
    @statuses = @campaign.statuses.desc.paginate(:page => params[:page], :per_page=>10)
    @donation = current_account.donations.for_campaign(@campaign.id).first if current_account

    respond_to do |format|
      format.html{}
      format.js {@donors = @campaign.donations.desc.limit(12).all}
    end
  end

  def donate
    @account = Account.first(:conditions => {:screen_name => params[:id]})

    render_not_found and return unless @account and @account.campaign

    session[:return_to] = campaign_permalink_path(@account.campaign)
    redirect_to get_twitter_request_token.authorize_url.gsub("authorize","authenticate")
  end

  private

  def new_campaign
    redirect_to campaign_permalink_path(current_account.campaign) if current_account.campaign
    @campaign = Campaign.new(params[:campaign])
  end

  def load_campaign
    @campaign = current_account.campaign
    render_not_found and return unless @campaign
  end
end