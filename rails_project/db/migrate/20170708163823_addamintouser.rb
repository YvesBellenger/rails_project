class Addamintouser < ActiveRecord::Migration[5.0]
  change_table :users do |t|
    t.remove :mail
    t.boolean :admin, :default => false
  end
end
