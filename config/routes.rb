Rails.application.routes.draw do
  resources :filled_items
  root to: 'welcome#index'

  get '/email_request_for_tender/:id',
      to: 'request_for_tenders#email_request_for_tender',
      as: 'email_request_for_tender'

  get '/show_interest_in_request_for_tender/:id',
      to: 'participants#show_interest_in_request_for_tender',
      as: 'show_interest_in_request_for_tender'

  get '/show_disinterest_in_request_for_tender/:id',
      to: 'participants#show_disinterest_in_request_for_tender',
      as: 'show_disinterest_in_request_for_tender'

  resources :items
  resources :sections
  resources :pages
  resources :boqs
  resources :participants
  resources :request_for_tenders
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
