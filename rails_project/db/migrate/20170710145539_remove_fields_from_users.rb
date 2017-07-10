class RemoveFieldsFromUsers < ActiveRecord::Migration[5.0]
  change_table :users do |t|
    t.remove :admin
  end
end
