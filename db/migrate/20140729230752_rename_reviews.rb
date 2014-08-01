class RenameReviews < ActiveRecord::Migration
  def change
    rename_table :video_reviews, :reviews
  end
end
