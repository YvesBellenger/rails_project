json.extract! reservation, :id, :livre, :user, :date_debut, :date_fin, :created_at, :updated_at
json.url reservation_url(reservation, format: :json)
