class Review < ActiveRecord::Base
  belongs_to :video
  belongs_to :user
  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'

  delegate :title, to: :video, prefix: :video

  validates_presence_of :body, :rating, :user, :video


end