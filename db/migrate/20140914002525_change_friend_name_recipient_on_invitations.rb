class ChangeFriendNameRecipientOnInvitations < ActiveRecord::Migration
  def change
    rename_column :invitations, :freind_name, :recipient_name
    rename_column :invitations, :freind_email, :recipient_email
  end
end
