Myflix::Application.routes.draw do
  root to: 'pages#front'

  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'home#index'
  get '/register', to: 'users#new'
  get '/login', to: 'sessions#new', as: :sessions_new
  post '/login', to: 'sessions#create'
  get '/log_out', to: 'sessions#destroy'
  

  resources :video, only: [:show] do
    collection do
      get 'search', to: 'video#search'
    end
  end

  resources :category
  resources :users, only: [:create]
end
