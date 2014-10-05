class AddLoginIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :login_id, :string
    add_index :users, :login_id, unique: true
  end
end
