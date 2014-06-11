class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :participant_id
      t.integer :item_id
      t.integer :price
      t.boolean :status

      t.timestamps
    end
  end
end
