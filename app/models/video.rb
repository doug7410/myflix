class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews , -> { order "created_at DESC" }
  has_many :queue_items

has_many :sssss
  validates_presence_of :title, :description

  def self.search_by_title(search_term)
    if search_term.blank?
      []
    else
      Video.where('title LIKE ?', "%#{search_term}%").order("created_at ASC")
    end
  end
 :aaaaa
  def average_rating
    reviews.average(:rating).round(2) if reviews.average(:rating)
  end 
end


