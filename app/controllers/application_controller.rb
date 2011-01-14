class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_account

  rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
  rescue_from ActionController::MethodNotAllowed, :with => :render_not_found unless Rails.env == "development"
  rescue_from ActionView::MissingTemplate, :with => :render_not_found unless Rails.env == "development"

  def current_account=(account)
    @current_account = account
    session[:current_account] = account.id
  end

  private

  helper_method :render_not_found
  def render_not_found
    render :layout => nil, :file => "#{RAILS_ROOT}/public/404.html", :status => "404 Not Found"
  end

  def render_access_denied
    render :layout => nil, :file => "#{RAILS_ROOT}/public/403.html", :status => "403 Forbidden"
  end

  def current_account
    return @current_account if defined?(@current_account)
    @current_account = Account.find(session[:current_account]) unless session[:current_account].blank?
  end

  def login_required
    unless current_account
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to "/"
      return false
    end
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def redirect_back_or_default(default)
    flash[:notice] = session[:return_flash] if session[:return_flash]
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
    session[:return_flash] = nil
  end
end
