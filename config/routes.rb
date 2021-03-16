Rails.application.routes.draw do
  devise_for :users
  root to: 'trips#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :trips, only: [:new, :create, :index, :show, :destroy] do
    resources :rooms, only: [:new, :create, :show] do
      member do
        put "like" => "rooms#like"
      end
    end
  end
  resources :participants, only: [:new, :create, :destroy]
end
