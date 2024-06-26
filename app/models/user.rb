class User < ApplicationRecord
  has_secure_password

  # Basic checks to validate user credentials
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: /\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\z/ }
  validates :password, length: { minimum: 8 }, if: :password_digest_changed?

  validates :points_balance, numericality: { greater_than_or_equal_to: 0 }
end
