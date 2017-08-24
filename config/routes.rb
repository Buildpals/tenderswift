Rails.application.routes.draw do
  resources :boqs
  resources :participants
  resources :requests
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
