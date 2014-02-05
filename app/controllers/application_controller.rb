##
# Donate Your Account (donateyouraccount.com)
# Copyright (C) 2011  Kyle Shank (kyle.shank@gmail.com)
# http://www.gnu.org/licenses/agpl.html
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
# 
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
##
class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_accounts
  helper_method :current_twitter_account
  helper_method :current_facebook_account
  helper_method :logged_in?

  rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
  rescue_from ActionController::MethodNotAllowed, :with => :render_not_found unless Rails.env == "development"
  rescue_from ActionView::MissingTemplate, :with => :render_not_found unless Rails.env == "development"

  before_filter :load_campaign_domain
  before_filter :redirect_if_campaign_domain

  def current_twitter_account=(account)
    @current_twitter_account = account
    session[:current_twitter_account] = account.id
  end

  def current_facebook_account=(account)
    @current_facebook_account = account
    session[:current_facebook_account] = account.id
  end

  protected

  def load_campaign_domain
    @premium_campaign = Campaign.where(:domain => request.host).first
  end

  def redirect_if_campaign_domain
    if @premium_campaign
      redirect_to "http://#{@premium_campaign.domain}"
      return false
    end
  end

  def redirect_to_dya_if_campaign_domain
    if @premium_campaign
      redirect_to "#{request.protocol}#{DYA_DOMAIN}#{request.path}?#{request.query_string}"
      return false
    end
  end

  helper_method :render_not_found
  def render_not_found
    render :layout => nil, :file => "#{Rails.root}/public/404.html", :status => "404 Not Found"
  end

  def render_access_denied
    render :layout => nil, :file => "#{Rails.root}/public/403.html", :status => "403 Forbidden"
  end

  def current_twitter_account
    return @current_twitter_account if defined?(@current_twitter_account)
    @current_twitter_account = Account.find(session[:current_twitter_account]) unless session[:current_twitter_account].blank?
  end

  def current_facebook_account
    return @current_facebook_account if defined?(@current_facebook_account)
    @current_facebook_account = Account.find(session[:current_facebook_account]) unless session[:current_facebook_account].blank?
  end

  def login_required
    unless current_twitter_account or current_facebook_account
      store_location
      if self.class.name.match(/^facebook.+$/i)
        redirect_to new_facebook_account_path
      elsif self.class.name.match(/^twitter.+$/i)
        redirect_to new_twitter_account_path
      else
        flash[:notice] = "You must be logged in to access this page"
        redirect_to "/"
      end
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

  def logged_in?
    current_facebook_account or current_twitter_account
  end

  def current_accounts
    a = []
    a << current_twitter_account if current_twitter_account
    a << current_facebook_account  if current_facebook_account
    a
  end
end
