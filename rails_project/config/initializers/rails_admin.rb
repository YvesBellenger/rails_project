RailsAdmin.config do |config|
  config.parent_controller = 'ApplicationController'

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  ## == Cancan ==
  config.authorize_with :cancan, AdminAbility

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.model 'Reservation' do
    edit do
      field :date_fin do
        strftime_format '%d-%m-%Y'
      end
      field :rendu
    end
  end

  config.model 'Book' do
    edit do
      field :title
      field :text
      field :author
      field :date do
        strftime_format '%d-%m-%Y'
      end
      field :stock
      field :avatar
      field :google_book_id
    end
  end

  config.model 'User' do
    edit do
      field :nom
      field :prenom
      field :email
      field :password
      field :password_confirmation
      field :roles
    end
  end
end
