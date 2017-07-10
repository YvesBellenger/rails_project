class RemoveRemoteUrlToBooks < ActiveRecord::Migration[5.0]
  change_table :books do |t|
    t.remove :remote_url
  end
end
