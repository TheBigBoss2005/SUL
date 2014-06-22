class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :user_id
      t.text :memo
      t.integer :event_id
      t.integer :price

      t.timestamps
    end
  end
end
