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
