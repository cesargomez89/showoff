class User < ApplicationRecord
  has_secure_password validations: false
  has_many :refresh_tokens, dependent: :destroy

  validates :email, presence: true, uniqueness: true
end
