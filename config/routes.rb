Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'index#view'
  get 'index/view'

  resource :index, to: 'index#view'

  match '/', to: 'index#job', via: 'post'

  # Healthcheck to be utilized.
  # match '/health', to: 'index#health', via: 'get'
  ## Sessions
  match '/login', to: 'sessions#view', via: 'get'
  match '/login', to: 'sessions#create', via: 'post'
  match '/login', to: 'sessions#destroy’', via: 'get'

  ## Signup
  match '/signup', to: 'signup#view', via: 'get'
  match '/signup', to: 'signup#job', via: 'post'
end
