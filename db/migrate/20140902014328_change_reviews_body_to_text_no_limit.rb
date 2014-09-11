class ChangeReviewsBodyToTextNoLimit < ActiveRecord::Migration
  def change
    change_column :reviews, :body, :text, :limit => nil
  end
end
