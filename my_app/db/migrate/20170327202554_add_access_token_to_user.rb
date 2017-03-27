class AddAccessTokenToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :access_token, :string, unique: true, index: true
  end
end
