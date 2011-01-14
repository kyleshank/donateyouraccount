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
