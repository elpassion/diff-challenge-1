class CreatePurchasers < ActiveRecord::Migration[5.0]
  def change
    create_table :purchasers do |t|
      t.belongs_to :user
      t.belongs_to :order
    end
  end
end
