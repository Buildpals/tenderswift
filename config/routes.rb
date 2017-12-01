Rails.application.routes.draw do

  get 'participants/:id/show', to: 'participants#messages', as: 'participants_messages'
  get 'participants/:id/project_information', to: 'participants#project_information', as: 'participants_project_information'
  get 'participants/:id/questionnaire', to: 'participants#questionnaire', as: 'participants_questionnaire'
  get 'participants/:id/boq', to: 'participants#boq', as: 'participants_boq'
  get 'participants/:id/results', to: 'participants#results', as: 'participants_results'

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


  get '/tender/:id/edit', to: 'create_tender#edit_tender_information', as: 'edit_tender_information'
  patch '/tender/:id/update/project_information', to: 'create_tender#update_tender_information', as: 'update_tender_information'

  get '/tender/:id/edit/documents', to: 'create_tender#edit_tender_documents', as: 'edit_tender_documents'
  patch '/tender/:id/update/documents', to: 'create_tender#update_tender_documents', as: 'update_tender_documents'

  get '/tender/:id/edit/boq', to: 'create_tender#edit_tender_boq', as: 'edit_tender_boq'
  patch '/tender/:id/update/boq', to: 'create_tender#update_tender_boq', as: 'update_tender_boq'

  get '/tender/:id/edit/questionnaire', to: 'create_tender#edit_tender_questionnaire', as: 'edit_tender_questionnaire'
  patch '/tender/:id/update/questionnaire', to: 'create_tender#update_tender_questionnaire', as: 'update_tender_questionnaire'

  get '/tender/:id/edit/participants', to: 'create_tender#edit_tender_participants', as: 'edit_tender_participants'
  patch '/tender/:id/update/participants', to: 'create_tender#update_tender_participants', as: 'update_tender_participants'

  get '/request_for_tenders/:id/preview', to: 'request_for_tenders#preview', as: 'request_for_tender_preview'

  devise_for :quantity_surveyors
  devise_for :admins

  mount RailsAdmin::Engine => '/adonai', as: 'rails_admin'

  resources :items
  resources :pages
  resources :request_for_tenders
  resources :boqs
  resources :participants
  resources :filled_items
  resources :broadcast_messages, only: [:create]
  resources :messages
  resources :answer_boxes
  resources :questions
  resources :quantity_surveyors
  resources :messages, only: [:create]


  mount ActionCable.server => '/cable'
end
