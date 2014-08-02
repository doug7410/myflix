Myflix::Application.routes.draw do
  root to: 'pages#front'

  get '/home', to: 'home#index'
  get '/register', to: 'users#new'
  get '/login', to: 'sessions#new', as: :sessions_new
  post '/login', to: 'sessions#create'
  get '/log_out', to: 'sessions#destroy'

  

  resources :videos, only: [:show] do
    collection do
      get 'search', to: 'videos#search'
    end

    resources :reviews, only: [:create]
  end

  resources :category

  resources :users, only: [:create] do
    resources :queue_items, only: [:index]
  end

  get 'ui(/:action)', controller: 'ui' 
end
