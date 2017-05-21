class CreateReservations < ActiveRecord::Migration[5.0]
  def change
    create_table :reservations do |t|
      t.string :livre
      t.string :user
      t.date :date_debut
      t.date :date_fin

      t.timestamps
    end
  end
end
