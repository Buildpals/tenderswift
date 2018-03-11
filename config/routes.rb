Rails.application.routes.draw do
  resources :request_for_tenders
  root to: 'request_for_tenders#index'

  get '/tender/:id/edit', to: 'create_tender#edit_tender_information', as: 'edit_tender_information'
  patch '/tender/:id/update/project_information', to: 'create_tender#update_tender_information', as: 'update_tender_information'

  get '/tender/:id/edit/documents', to: 'create_tender#edit_tender_documents', as: 'edit_tender_documents'
  patch '/tender/:id/update/documents', to: 'create_tender#update_tender_documents', as: 'update_tender_documents'

  get '/tender/:id/edit/boq', to: 'create_tender#edit_tender_boq', as: 'edit_tender_boq'
  patch '/tender/:id/update/boq', to: 'create_tender#update_tender_boq', as: 'update_tender_boq'
  patch '/tender/:id/update/contract_sum_address', to: 'create_tender#update_contract_sum_address'

  get '/tender/:id/edit/required_documents', to: 'create_tender#edit_tender_required_documents', as: 'edit_tender_required_documents'
  patch '/tender/:id/update/required_documents', to: 'create_tender#update_tender_required_documents', as: 'update_tender_required_documents'

  get '/tender/:id/edit/payment_method', to: 'create_tender#edit_tender_payment_method', as: 'edit_tender_payment_method'
  patch '/tender/:id/update/payment_method', to: 'create_tender#update_tender_payment_method', as: 'update_tender_payment_method'
  patch '/payment/details/:id', to: 'create_tender#update_payment_details', as: 'update_payment_details'

  get '/tender/:id/edit/participants', to: 'create_tender#edit_tender_participants', as: 'edit_tender_participants'
  patch '/tender/:id/update/participants', to: 'create_tender#update_tender_participants', as: 'update_tender_participants'

  get '/projects/public/:id', to: 'request_for_tenders#portal', as: 'request_for_tender_portal'

  get '/participants/:id', to: 'participants#project_information', as: 'participants_project_information'
  get '/participants/:id/tender_documents', to: 'participants#tender_documents', as: 'participants_tender_documents'
  get '/participants/:id/required_documents', to: 'participants#required_documents', as: 'participants_required_documents'
  get '/participants/:id/boq', to: 'participants#boq', as: 'participants_boq'
  get '/participants/:id/other/documents', to: 'participants#other_documents', as: 'participant_other_documents'
  get '/participants/:id/results', to: 'participants#results', as: 'participants_results'
  patch '/participants/:id/rating', to: 'participants#rating', as: 'participant_ratings'

  post '/participants/pay_public_tender/', to: 'participants#pay_public_tender', as: 'pay_public_tender'
  post '/participants/:id/required_document_uploads/', to: 'participants#required_document_uploads', as: 'participants_upload_required_documents'
  patch '/participants/:id/other_document_uploads/', to: 'participants#other_document_uploads', as: 'participant_other_documents_upload'
  post '/participants/save_rates/:id/', to: 'participants#save_rates'
  get '/tender/transactions/complete_transaction/', to: 'tender_transactions#complete_transaction', as: 'complete_transaction'

  get '/bids/:id', to: 'bids#required_documents', as: 'bid_required_documents'
  get '/bids/:id/boq', to: 'bids#boq', as: 'bid_boq'
  get '/bids/:id/other_documents', to: 'other_document_uploads#other_documents', as: 'bid_other_documents'

  get '/bids/:id/pdf_viewer/:required_document_upload_id', to: 'bids#pdf_viewer', as: 'view_pdf'
  get '/bids/:id/image_viewer/:required_document_upload_id', to: 'bids#image_viewer', as: 'view_image'
  get '/bids/:id/pdf_viewer/other/:other_document_id', to: 'other_document_uploads#pdf_viewer', as: 'view_pdf_for_other_documents'
  get '/bids/:id/image_viewer/other/:other_document_id', to: 'other_document_uploads#image_viewer', as: 'view_image_for_other_documents'

  get '/request_for_tenders/:id/compare_boq', to: 'request_for_tenders#compare_boq', as: 'compare_boq'

  patch '/bids/update/:required_document_upload_id', to: 'bids#update', as: 'update_bid'
  patch '/bids/update/other/:other_document_id', to: 'other_document_uploads#update', as: 'update_other_document'
  post '/bids/disqualify/:id/', to: 'bids#disqualify', as: 'disqualify_bid'
  post '/bids/undo_disqualify/:id/', to: 'bids#undo_disqualify', as: 'undo_disqualify_bid'
  post '/bids/rate/:id/', to: 'bids#rate', as: 'rate_bid'

  resources :quantity_surveyors, only: %i[edit update]
  resources :request_for_tenders
  resources :participants
  resources :tender_transactions, only: %i[create update]

  devise_for :quantity_surveyors
  devise_for :admins

  mount RailsAdmin::Engine => '/adonai', as: 'rails_admin'

  mount ActionCable.server => '/cable'
end