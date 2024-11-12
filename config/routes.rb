Rails.application.routes.draw do
  # Define RESTful routes for movies, limiting to the index action
  resources :movies, only: [:index]

  # Set the root path of the application to movies#index
  root 'movies#index'
end
