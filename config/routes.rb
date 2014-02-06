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
      get 'oauth_create' => "facebook_accounts#create", :as => :oauth_create
    end
  end
  resources :twitter_accounts do
    collection do
      get 'oauth_create' => "twitter_accounts#create", :as => :oauth_create
    end
  end
  resources :campaigns do
    resources :donations do
      collection do
        get :twitter
        post 'twitter' => "donations#twitter_create", :as => :twitter_create
        get :facebook
        post 'facebook' => "donations#facebook_create", :as => :facebook_create
      end
      member do
        get :delete
        get :thanks
      end
    end
    resources :twitter_statuses
    resources :facebook_statuses
  end

  get 'start' => "dya#start", :as => :start
  get 'home' => "dya#home", :as => :dashboard
  get 'signout' => "dya#signout", :as => :signout

  post 'facebook_accounts/new' => "facebook_accounts#new"

  get '/' => 'campaigns#show', :constraints => { :host => /^((?!#{DYA_DOMAIN}).)*$/ }  
  root :to => "dya#index"

  get ':id(.:format)' => "campaigns#show", :as => :campaign_permalink
end
