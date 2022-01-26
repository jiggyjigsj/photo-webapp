Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'index#view'
  get 'index/view'

  resource :index, to: 'index#view'

  match '/', to: 'index#view', via: 'get'
  match '/', to: 'index#job', via: 'post'

  # Healthcheck to be utilized.
  # match '/health', to: 'index#health', via: 'get'
  ## Sessions
  match '/login', to: 'sessions#view', via: 'get'
  match '/login', to: 'sessions#create', via: 'post'
  match '/logout', to: 'sessions#destroy', via: 'get'

  ## Contacts
  match '/contacts', to: 'contacts#view', via: 'get'
  match '/contacts', to: 'contacts#job', via: 'post'

  ## Signup
  match '/signup', to: 'signup#view', via: 'get'
  match '/signup', to: 'signup#job', via: 'post'
end
