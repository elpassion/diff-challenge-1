class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true

  before_create :set_access_token
  has_and_belongs_to_many :groups, join_table: 'memberships', foreign_key: 'user_id'

  private

  def set_access_token
    self.access_token = SecureRandom.uuid
  end
end
