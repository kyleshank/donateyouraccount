class DyaController < ApplicationController
  def index
    redirect_to dashboard_path and return if current_account
    render :layout => false
  end

  def signout
    @current_account = nil
    session.delete(:current_account)
    redirect_to "/"
  end
end