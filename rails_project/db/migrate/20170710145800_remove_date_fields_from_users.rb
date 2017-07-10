class RemoveDateFieldsFromUsers < ActiveRecord::Migration[5.0]
  change_table :users do |t|
    t.remove :date_inscription
  end
end
