class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  validates_numericality_of :list_order, {only_integer: true}

  def rating
    user.reviews.where(video: video).first.try(:rating)
  end

  def category_name
    video.category.name
  end 

end