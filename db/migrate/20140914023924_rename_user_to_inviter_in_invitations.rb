class RenameUserToInviterInInvitations < ActiveRecord::Migration
  def change
    rename_column :invitations, :user_id, :inviter_id
  end
end
