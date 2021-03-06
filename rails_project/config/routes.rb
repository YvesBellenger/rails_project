Rails.application.routes.draw do
  devise_for :users, :controllers => { :registrations => "registrations"}
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # resources :reservations
  resources :users

  resources :books do
    resources :reservations
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'



  post "books/:book_id/reservations/:id" => 'reservations#livre_rendu'
  get '/reservations' => 'reservations#reservations_all'
  get '/reservations/rendus' => 'reservations#reservations_all_rendus'
  get '/searchadd' => 'books#searchadd', as: :search_path
  get '/searchadd/bookinfos' => 'books#searchaddinfos'
  post '/books/new' => 'books#add_book_api'

  get '/profil' => 'users#profil', as: :profil_path


end