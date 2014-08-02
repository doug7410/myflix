class User < ActiveRecord::Base
  has_many :reviews , -> { order "created_at DESC" }
  has_many :queue_items, -> { order "list_order ASC"}

  has_secure_password validations: false

  validates :password, presence: :true, length: {minimum: 6}, on: :create
  validates :email, presence: :true, uniqueness: true
  validates :full_name, presence: :true
end