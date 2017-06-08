class UpdateReservation < ActiveRecord::Migration[5.0]
  def change
    change_table :reservations do |t|
      t.remove :livre, :user
      t.references :books, :users
      t.boolean :rendu, :default => false
    end
  end
end
