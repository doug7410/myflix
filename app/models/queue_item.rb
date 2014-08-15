class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  validates_numericality_of :list_order, {only_integer: true}

  def rating
    review.rating if review
  end

  def rating=(new_rating)
    if review
      review.update_column(:rating, new_rating)
    else
      review = Review.new(user: user, video: video, rating: new_rating)
      review.save validate: false
    end
  end

  def category_name
    video.category.name
  end 

  private

  def review
    @review ||= Review.where(video_id: video.id, user_id: user.id).last
  end

end