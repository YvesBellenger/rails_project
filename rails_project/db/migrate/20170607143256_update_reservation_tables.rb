class UpdateReservationTables < ActiveRecord::Migration[5.0]
  def change
    change_table :reservations do |t|
      t.remove :users_id,:books_id
    end
  end
end
