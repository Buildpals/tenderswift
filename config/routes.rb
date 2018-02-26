Rails.application.routes.draw do

  root to: 'welcome#index'

  get '/tender/:id/edit', to: 'create_tender#edit_tender_information', as: 'edit_tender_information'
  patch '/tender/:id/update/project_information', to: 'create_tender#update_tender_information', as: 'update_tender_information'

  get '/tender/:id/edit/documents', to: 'create_tender#edit_tender_documents', as: 'edit_tender_documents'
  patch '/tender/:id/update/documents', to: 'create_tender#update_tender_documents', as: 'update_tender_documents'

  get '/tender/:id/edit/boq', to: 'create_tender#edit_tender_boq', as: 'edit_tender_boq'
  patch '/tender/:id/update/boq', to: 'create_tender#update_tender_boq', as: 'update_tender_boq'

  get '/tender/:id/edit/questionnaire', to: 'create_tender#edit_tender_questionnaire', as: 'edit_tender_questionnaire'
  patch '/tender/:id/update/questionnaire', to: 'create_tender#update_tender_questionnaire', as: 'update_tender_questionnaire'

  get '/tender/:id/edit/payment_method', to: 'create_tender#edit_tender_payment_method', as: 'edit_tender_payment_method'
  patch '/tender/:id/update/payment_method', to: 'create_tender#update_tender_payment_method', as: 'update_tender_payment_method'

  get '/tender/:id/edit/participants', to: 'create_tender#edit_tender_participants', as: 'edit_tender_participants'
  patch '/tender/:id/update/participants', to: 'create_tender#update_tender_participants', as: 'update_tender_participants'

  get 'participants/:id', to: 'participants#messages', as: 'participants_messages'
  get 'participants/:id/project_information', to: 'participants#project_information', as: 'participants_project_information'
  get 'participants/:id/tender_document', to: 'participants#tender_document', as: 'participants_tender_document'
  post 'participants/:id/required_document_uploads/', to: 'participants#required_document_uploads', as: 'participants_upload_required_documents'
  get 'participants/:id/questionnaire', to: 'participants#questionnaire', as: 'participants_questionnaire'
  get 'participants/:id/boq', to: 'participants#boq', as: 'participants_boq'
  get 'participants/:id/results', to: 'participants#results', as: 'participants_results'
  post 'participants/pay_public_tender/', to: 'participants#pay_public_tender', as: 'pay_public_tender'

  get 'tender/transactions/complete_transaction/', to: 'tender_transactions#complete_transaction', as: 'complete_transaction'

  get 'projects/public/:id', to: 'request_for_tenders#portal', as: 'request_for_tender_portal'

  get 'bids/:id/show', to: 'bids#show', as: 'view_bid'
  get 'bids/:id/pdf_viewer/:participant_id', to: 'bids#pdf_viewer', as: 'view_pdf'
  patch 'bids/update/:id', to: 'bids#update', as: 'update_bid'
  get 'bids/:id', to: 'bids#boq', as: 'bid_boq'
  get 'bids/:id/messages', to: 'bids#messages', as: 'bid_messages'
  get 'bids/:id/questionnaire', to: 'bids#questionnaire', as: 'bid_questionnaire'
  get 'bids/:id/information', to: 'bids#contractor_information', as: 'bid_contractor_information'

  get '/request/compare/bids/:id',
      to: 'request_for_tenders#compare_bids',
      as: 'compare_bids'

  get 'participants/complete_transaction/:transaction_id/:status/:message',
      to: 'participants#complete_transaction',
      as: 'participants_complete_transaction'

  post '/participants/disqualify/:id/',
       to: 'participants#disqualify'

  post '/participants/undo_disqualify/:id/',
       to: 'participants#undo_disqualify'

  post '/participants/rate/:id/',
       to: 'participants#rate'

  resources :quantity_surveyors, only: %i[edit update]
  resources :request_for_tenders
  resources :participants
  resources :tender_transactions
  resources :rates

  devise_for :quantity_surveyors
  devise_for :admins

  mount RailsAdmin::Engine => '/adonai', as: 'rails_admin'

  mount ActionCable.server => '/cable'
end
