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
  resources :facebook_accounts do
    collection do
      match 'oauth_create' => "facebook_accounts#create", :as => :oauth_create, :via => :get
    end
  end
  resources :twitter_accounts do
    collection do
      match 'oauth_create' => "twitter_accounts#create", :as => :oauth_create, :via => :get
    end
  end
  resources :campaigns do
    resources :donations do
      collection do
        get :twitter
        match 'twitter' => "donations#twitter_create", :as => :twitter_create, :via => :post
        get :facebook
        match 'facebook' => "donations#facebook_create", :as => :facebook_create, :via => :post
      end
      member do
        get :delete
      end
    end
    resources :twitter_statuses
    resources :facebook_statuses
  end

  match 'home' => "dya#home", :as => :dashboard
  match 'signout' => "dya#signout", :as => :signout

  root :to => "dya#index"

  match ':id(.:format)' => "campaigns#show", :as => :campaign_permalink
end
