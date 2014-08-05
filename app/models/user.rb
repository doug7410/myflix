class User < ActiveRecord::Base
  has_many :reviews , -> { order "created_at DESC" }
  has_many :queue_items, -> { order "list_order ASC"}

  has_secure_password validations: false

  validates :password, presence: :true, length: {minimum: 6}, on: :create
  validates :email, presence: :true, uniqueness: true
  validates :full_name, presence: :true

  def video_is_in_queue?(video)
    true if queue_items.where(video: video).present?
  end

  def add_queue_item!(video)
    QueueItem.create(video: video, user: self, list_order: list_order) unless current_user_queued_video?(video)
  end

  def list_order 
    queue_items.size + 1
  end

  def current_user_queued_video?(video)
    queue_items.where(video: video).present?
  end

end