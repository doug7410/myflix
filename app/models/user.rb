class User < ActiveRecord::Base
  has_many :reviews , -> { order "created_at DESC" }
  has_many :queue_items, -> { order "list_order ASC"}

  has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id
  has_many :leading_relationships, class_name: "Relationship", foreign_key: :leader_id

  has_secure_password validations: false

  validates :password, presence: :true, length: {minimum: 6}, on: :create
  validates :email, presence: :true, uniqueness: true
  validates :full_name, presence: :true

  def generate_token
    self.token = SecureRandom.urlsafe_base64 
    self.token_created_at = Time.now
    self.save
  end

  def follows?(another_user)
    following_relationships.map(&:leader).include?(another_user)
  end

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

  def normalize_queue_item_postitions
    self.queue_items.each_with_index do |item, index|
      item.update!(list_order: index + 1)
    end
  end
end
