class Payments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :user_id
      t.integer :ammount_in_cents
      t.string :reference_id
      t.timestamps
    end
  end
end
