class Invitation < ActiveRecord::Base
  belongs_to :user
  belongs_to :inviter, class_name: 'User' 

  validates_presence_of :recipient_email, :recipient_name, :message

  before_create :generate_random_token

  def generate_random_token
    self.token = SecureRandom.urlsafe_base64
  end
end
