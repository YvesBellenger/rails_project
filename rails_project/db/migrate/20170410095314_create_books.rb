class CreateBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :books do |t|
      t.string :title
      t.text :text
      t.string :author
      t.datetime :date
      t.integer :stock

      t.timestamps
    end
  end
end
