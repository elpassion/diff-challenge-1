class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.references :founder, index: true, foreign_key: { to_table: :users }
      t.string :restaurant
      t.timestamps
    end
  end
end
