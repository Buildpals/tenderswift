# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :contractors do
    get '/after_signup', to: 'after_signup#edit', as: :after_signup
    patch '/after_signup', to: 'after_signup#update'
  end

  get '/',
      to: 'welcome#query_request_for_tender',
      constraints: {
        subdomain: 'public'
      }

  get '/:id',
      to: 'purchase_tender#portal',
      constraints: {
        subdomain: 'public'
      }

  root to: 'welcome#index'

  #################### Publisher Routes ##################

  devise_for :publishers, path: 'publishers', controllers: {
    confirmations: 'publishers/confirmations',
    passwords: 'publishers/passwords',
    registrations: 'publishers/registrations',
    sessions: 'publishers/sessions',
    unlocks: 'publishers/unlocks'
  }

  get '/publishers/dashboard',
      to: 'publishers#dashboard',
      as: :publisher_root

  resources :publishers, only: %i[edit update]

  resources :request_for_tenders, only: %i[show update destroy] do
    resources :build, controller: 'request_for_tenders/build'
    resources :project_documents, only: %i[create destroy]
    resource :excel_file
  end

  get '/request_for_tenders/:id/confirm_publishing',
      to: 'request_for_tenders#show',
      as: :confirm_publishing

  get '/request_for_tenders/:id/cash_out_now',
      to: 'request_for_tenders#cash_out_now',
      as: :cash_out_request_for_tender

  # Routes for bid

  get '/bids/:id',
      to: 'bids#required_documents',
      as: :bid_required_documents

  get '/bids/:id/boq',
      to: 'bids#boq',
      as: :bid_boq

  get '/bids/:id/other_documents',
      to: 'bids#other_documents',
      as: :bid_other_documents

  get '/required_documents/:id',
      to: 'required_document_uploads#show',
      as: :required_document_upload

  patch '/required_documents/:id/approve',
        to: 'required_document_uploads#approve',
        as: :approve_required_document_upload

  patch '/required_documents/:id/reject',
        to: 'required_document_uploads#reject',
        as: :reject_required_document_upload

  get '/other_documents/:id',
      to: 'other_document_uploads#show',
      as: :other_document_upload

  patch '/other_documents/:id/approve',
        to: 'other_document_uploads#approve',
        as: :approve_other_document_upload

  patch '/other_documents/:id/reject',
        to: 'other_document_uploads#reject',
        as: :reject_other_document_upload

  patch '/bids/:id/disqualify',
        to: 'bids#disqualify',
        as: :disqualify_bid

  patch '/bids/:id/undo_disqualify',
        to: 'bids#undo_disqualify',
        as: :undo_disqualify_bid

  patch '/bids/:id/score',
        to: 'bids#score',
        as: :score_bid

  get '/request_for_tenders/:id/details',
      to: 'request_for_tenders#details',
      as: :request_for_tender_details

  get '/request_for_tenders/:id/compare_boq',
      to: 'request_for_tenders#compare_boq',
      as: :compare_boq

  #################### Contractors Routes ##################

  devise_for :contractors, path: 'contractors', controllers: {
    confirmations: 'contractors/confirmations',
    passwords: 'contractors/passwords',
    registrations: 'contractors/registrations',
    sessions: 'contractors/sessions',
    unlocks: 'contractors/unlocks'
  }

  get '/contractors/dashboard',
      to: 'contractors#dashboard',
      as: :contractor_root

  resources :contractors, only: %i[edit update]

  get '/purchase_tender',
      to: 'welcome#query_request_for_tender',
      as: :query_request_for_tender

  get '/query',
      to: 'welcome#find_request_for_tender',
      as: :find_request_for_tender

  # Routes for purchase_tender

  get '/purchase_tender/complete_transaction',
      to: 'purchase_tender#complete_transaction',
      as: :complete_transaction

  get '/purchase_tender/:id',
      to: 'purchase_tender#portal',
      as: :purchase_tender

  get '/purchase_tender/:id/payment',
      to: 'purchase_tender#payment',
      as: :buy_request_for_tender

  post '/purchase_tender/:id',
       to: 'purchase_tender#purchase'

  get '/purchase_tender/:id/monitor_purchase',
      to: 'purchase_tender#monitor_purchase',
      as: :monitor_purchase

  # Routes for tender

  resources :tenders, only: %i[destroy] do
    resources :build, controller: 'tenders/build'
    resources :view, controller: 'tenders/view'

    resources :other_document_uploads,
              only: %i[create destroy],
              module: 'tenders'

    resources :required_document_uploads,
              only: %i[create update destroy],
              module: 'tenders'
  end

  #################### Admin Routes ##################

  devise_for :admins, path: 'admins', controllers: {
    confirmations: 'admins/confirmations',
    passwords: 'admins/passwords',
    sessions: 'admins/sessions',
    unlocks: 'admins/unlocks'
  }

  get '/review_request_for_tenders',
      to: 'admins#review_request_for_tenders',
      as: :admin_root

  get '/review_request_for_tenders',
      to: 'admins#review_request_for_tenders',
      as: :review_request_for_tenders

  get '/review_request_for_tenders/:id',
      to: 'admins#review_request_for_tender',
      as: :review_request_for_tender

  get '/monitor_request_for_tenders/:id',
      to: 'admins#monitor_request_for_tender',
      as: :monitor_request_for_tender

  delete '/reverse_masquerade/:id',
         to: 'admins#reverse_masquerade',
         as: :reverse_masquerade

  mount RailsAdmin::Engine => '/adonai', as: :rails_admin
  mount ActionCable.server => '/cable'
end
