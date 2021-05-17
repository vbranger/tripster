Rails.application.routes.draw do
  devise_for :users, :controllers => { :registrations => "users/registrations",
                                       :confirmations => "users/confirmations" }
  root to: 'trips#index'

  get 'waiting_confirmation', to: 'pages#waiting_confirmation'
  get 'room_process', to: 'pages#room_process'

  get 'trips/:id/reset_dates', to: 'trips#reset_dates', as: 'reset_dates'
  get 'trips/:id/edit_destination', to: 'trips#edit_destination', as: 'edit_destination'
  get 'trips/:id/edit_dates', to: 'trips#edit_dates'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :trips, only: [:new, :create, :index, :show, :destroy, :update] do
    put :start_propositions
    put :start_votes
    put :back_propositions
    put :back_votes
    get :reset_vote
    resources :rooms, only: [:new, :create, :index, :show, :destroy, :update] do
      put :choose_room
      resources :reviews, only: [ :new, :create, :index, :edit, :update ]
      member do
        put "like" => "rooms#like"
      end
    end
  end
  resources :rooms, only: [:edit, :update]
  resources :participants, only: [:new, :create, :destroy] do
    patch :save_room_votes
  end
  resources :invites
end
