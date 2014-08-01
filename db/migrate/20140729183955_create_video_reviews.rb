class CreateVideoReviews < ActiveRecord::Migration
  def change
    create_table :video_reviews do |t|
      t.string :body
      t.integer :rating
      t.integer :user_id
      t.timestamps
    end
  end
end
