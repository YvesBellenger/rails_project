class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :nom
      t.string :prenom
      t.string :description
      t.string :mail
      t.date :date_inscription

      t.timestamps
    end
  end
end