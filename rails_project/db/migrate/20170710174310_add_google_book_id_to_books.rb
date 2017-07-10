class AddGoogleBookIdToBooks < ActiveRecord::Migration[5.0]
  def change
    change_table :books do |t|
      t.string :google_book_id
    end
  end
end
