Rails.application.routes.draw do
  devise_for :users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # resources :reservations
  resources :users

  resources :books do
    resources :reservations
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'

  post "books/:book_id/reservations/:id" => 'reservations#livre_rendu'
end