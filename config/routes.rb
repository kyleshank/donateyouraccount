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
Dya::Application.routes.draw do
  resources :accounts do
    collection do
      match 'oauth_create' => "accounts#create", :as => :oauth_create, :via => :get
    end
  end
  resource :campaign
  resources :donations
  resources :statuses

  match 'home' => "accounts#index", :as => :dashboard
  match 'signout' => "dya#signout", :as => :signout

  root :to => "dya#index"

  get ':id/donate' => "donations#new", :as => :campaign_donate
  post ':id/donate' => "donations#create"
  delete ':id/donate' => "donations#destroy"
  
  match ':id(.:format)' => "campaigns#show", :as => :campaign_permalink
end
