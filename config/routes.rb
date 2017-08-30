Rails.application.routes.draw do
  root to: 'welcome#index'

  resources :items
  resources :sections
  resources :pages
  resources :boqs
  resources :participants
  resources :request_for_tenders
  devise_for :quantity_surveyors
  resources :filled_items
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
