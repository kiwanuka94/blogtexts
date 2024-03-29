Rails.application.routes.draw do
  get 'messages/create'
  
  root 'pages#home'

  devise_for :users
  get 'logout', to: 'pages#logout', as: 'logout'

  resources :subscribe, only: [:index]
  get 'dashboard', to: 'widgets#index', as: 'dashboard_index'
  resources :account, only: [:index, :update]
  resources :billing_portal, only: [:create]
  match '/billing_portal' => 'billing_portal#create', via: [:get]
  match '/cancel' => 'billing_portal#destroy', via: [:get]

  # static pages
  pages = %w(
    privacy terms demo
  )

  pages.each do |page|
    get "/#{page}", to: "pages##{page}", as: "#{page.gsub('-', '_')}"
  end

  # admin panels
  authenticated :user, -> user { user.admin? } do
    namespace :admin do
      resources :dashboard, only: [:index]
      resources :impersonations, only: [:new]
      resources :users, only: [:edit, :update, :destroy]
    end

    # convenience helper
    get 'admin', to: 'admin/dashboard#index'
  end

  # more routes here
  resources :widgets, except: [:show]
  resources :messages, only: [:create, :index]
  get 'snippet', to: 'snippet#show'


end



