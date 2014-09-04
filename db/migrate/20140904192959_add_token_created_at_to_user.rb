class AddTokenCreatedAtToUser < ActiveRecord::Migration
  def change
    add_column :users, :token_created_at, :timestamp
  end
end
