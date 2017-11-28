Rails.application.routes.draw do
  resources :messages, only: [:create]
  resources :answer_boxes
  resources :questions
  resources :countries
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
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

  get '/participants/:id/boq',
      to: 'participants#show_boq',
      as: 'participant_boq'


  post '/requests/set_winner/:id/:participant',
      to: 'request_for_tenders#set_winner',
      as: 'request_for_tenders_set_winner'


  post '/requests/send_out/:id', 
      to: 'request_for_tenders#send_out_final_invitation',
      as: 'request_send_out_final_invitation'

  post '/requests/notify_disqualified_contractors/:id',
      to: 'request_for_tenders#notify_disqualified_contractors',
      as: 'notify_disqualified_contractors'

  patch '/participants/disqualify/:id/',
      to: 'participants#disqualify'
  
  devise_for :quantity_surveyors

  resources :items
  resources :sections
  resources :pages
  resources :request_for_tenders
  resources :boqs
  resources :participants do

  end
  resources :filled_items
  resources :broadcast_messages, only: [:create]
  #resources :chatrooms
  #resources :countries
  resources :tags

  mount ActionCable.server => '/cable'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
