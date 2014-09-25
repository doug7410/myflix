require 'sidekiq/web'

Myflix::Application.routes.draw do
  root to: 'pages#front'

  resources :videos, only: [:show] do
    collection do
      get 'search', to: 'videos#search'
    end

    resources :reviews, only: [:create]
  end

  resources :category
  resources :users, only: [:create, :show]
  resources :queue_items, only: [:create, :destroy]
  resources :relationships, only: [:destroy]


  get '/home', to: 'home#index'
  get '/register', to: 'users#new'
  get 'register/:token', to: 'users#new_with_invitation_token', as: 'register_with_token'
  get '/login', to: 'sessions#new', as: :sessions_new
  post '/login', to: 'sessions#create'
  get '/log_out', to: 'sessions#destroy'
  get '/my_queue', to: 'queue_items#index'
  patch '/my_queue', to: 'queue_items#update', as: :update_queue
  get 'people', to: 'relationships#index'
  post 'follow_person/:id', to: 'relationships#create', as: :follow_person
  get 'ui(/:action)', controller: 'ui' 

  get '/forgot_password', to: 'forgot_password#new'
  resources :forgot_password, only: [:create]
  get '/forgot_password_confirmation', to: 'forgot_password#confirm'
  resources :password_reset, only: [:show, :create]
  get '/expired_token', to: 'pages#expired_token'

  resources :invitations, only: [:new, :create]

  namespace :admin do
    resources :videos, only: [:new, :create]
  end


  mount Sidekiq::Web, at: '/sidekiq'
end
