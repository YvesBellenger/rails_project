class AddRemoteUrlToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :remote_url, :string
  end
end
