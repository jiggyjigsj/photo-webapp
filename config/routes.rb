Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'index#index'
  get 'index/index'

  get '/example', to: 'example#view'
end
