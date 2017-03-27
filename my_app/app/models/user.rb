class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true

  before_create :set_access_token

  private

  def set_access_token
    self.access_token = SecureRandom.uuid
  end
end
