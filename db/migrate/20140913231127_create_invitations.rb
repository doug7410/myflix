class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :user_id
      t.string :freind_name
      t.string :freind_email
      t.string :message
      t.timestamps
    end
  end
end
