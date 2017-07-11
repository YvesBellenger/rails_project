class ChangeDateFormatReservations < ActiveRecord::Migration[5.0]
  change_table :reservations do |t|
    t.change :date_debut, :datetime
    t.change :date_fin, :datetime
  end
end
