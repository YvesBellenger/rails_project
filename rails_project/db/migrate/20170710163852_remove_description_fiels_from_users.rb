class RemoveDescriptionFielsFromUsers < ActiveRecord::Migration[5.0]
  change_table :users do |t|
    t.remove :description
  end
end
