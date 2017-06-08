class UpdateReservationName < ActiveRecord::Migration[5.0]
  def change
    change_table :reservations do |t|
      t.remove :users, :books
      t.references :user, :book
    end
  end
end
