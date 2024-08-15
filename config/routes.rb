Rails.application.routes.draw do
  resources :sessions, only: %i[ show create destroy ]
  resources :users
  
  get "up" => "rails/health#show", as: :rails_health_check
end
