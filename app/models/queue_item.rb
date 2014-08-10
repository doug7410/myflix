class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  def rating
    user.reviews.where(video: video).first.try(:rating)
  end

  def category_name
    video.category.name
  end 
end