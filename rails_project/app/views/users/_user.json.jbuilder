json.extract! user, :id, :nom, :prenom, :description, :mail, :date_inscription, :created_at, :updated_at
json.url user_url(user, format: :json)
