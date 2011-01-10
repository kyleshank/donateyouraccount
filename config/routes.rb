Dya::Application.routes.draw do
  resources :accounts do
    collection do
      match 'oauth_create' => "accounts#create", :as => :oauth_create, :via => :get
    end
  end
  resource :campaign
  resources :donations
  resources :statuses

  match 'dashboard' => "accounts#index", :as => :dashboard
  match 'signout' => "dya#signout", :as => :signout

  root :to => "dya#index"

  match ':id(.:format)' => "campaigns#show", :as => :campaign_permalink
end
