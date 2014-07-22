Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'home#index'

  resources :video, only: [:show] do
    collection do
      get 'search', to: 'video#search'
    end
  end

  resources :category
end
