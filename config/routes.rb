Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'environment_readings#index'

  resources :messages, only: [:index]
end
