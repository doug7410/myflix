class AddVideoIdToVideoReviews < ActiveRecord::Migration
  def change
    add_column :video_reviews, :video_id, :integer
  end
end
