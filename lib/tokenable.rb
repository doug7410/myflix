module Tokenable
  extend ActiveSupport::Concern

  included do
    before_create :generate_random_token
  end
  

  def generate_random_token
    self.token = SecureRandom.urlsafe_base64
  end
end