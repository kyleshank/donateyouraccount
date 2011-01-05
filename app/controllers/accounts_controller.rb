class AccountsController < ApplicationController
  include AccountsHelper

  before_filter :login_required, :only => [:index]

  def index
    @donated_statuses = Status.donated_through_account(current_account).desc.paginate(:page => params[:page], :per_page=>10)
  end

  def show
    @account = Account.first(:conditions => {:screen_name => params[:id]})
    render_not_found and return unless @account
    @statuses = @account.statuses.desc.paginate(:page => params[:page], :per_page=>10)
    @donation = current_account.donations.for_campaign(@account.id).first if current_account
  end

  def new
    redirect_to get_twitter_request_token.authorize_url.gsub("authorize","authenticate")
  end

  def create
    consumer = OAuth::Consumer.new(Twitter.consumer_key, Twitter.consumer_secret, {:site=>"http://twitter.com" })
    request_token = OAuth::RequestToken.new(consumer, session[:request_token], session[:request_token_secret])

    begin
      access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
      response = consumer.request(:get, '/account/verify_credentials.json', access_token, { :scheme => :query_string })

      case response
        when Net::HTTPSuccess
          user_info = JSON.parse(response.body)

          @account = Account.first(:conditions => {:uid => user_info["id"]})

          unless @account
            @account = Account.new(
                :uid => user_info["id"],
                :screen_name => user_info["screen_name"],
                :token => access_token.token,
                :secret => access_token.secret
            )
          end

          @account.name = user_info["name"]
          @account.followers = (user_info["followers_count"] || 0).to_i
          @account.url = user_info["url"]
          @account.description = user_info["description"]
          @account.location = user_info["location"]
          @account.profile_sidebar_border_color = user_info["profile_sidebar_border_color"]
          @account.profile_sidebar_fill_color = user_info["profile_sidebar_fill_color"]
          @account.profile_link_color = user_info["profile_link_color"]
          @account.profile_image_url = user_info["profile_image_url"]
          @account.profile_background_color = user_info["profile_background_color"]
          @account.profile_background_image_url = user_info["profile_background_image_url"]
          @account.profile_text_color = user_info["profile_text_color"]
          @account.profile_background_tile = user_info["profile_background_tile"]
          @account.profile_use_background_image = user_info["profile_use_background_image"]

          if @account.save
            self.current_account=@account
          end

          redirect_back_or_default dashboard_path
      end
    rescue OAuth::Unauthorized
      request.flash.now["notice"] = "Oops! OAuth Unauthorized error."
      redirect_to "/"
    end
  end

  def donate
    @account = Account.first(:conditions => {:screen_name => params[:id]})
    redirect_to :back and return unless @account

    session[:return_to] = account_permalink_path(@account)
    redirect_to get_twitter_request_token.authorize_url.gsub("authorize","authenticate")
  end
end
