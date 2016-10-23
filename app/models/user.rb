class User < ApplicationRecord
  validates :first_name, presence: true, length: {maximum: 20}
  validates :last_name, presence: true, length: {maximum: 20}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 30}, format: { with: VALID_EMAIL_REGEX}, uniqueness: { case_sensitive: false}

  has_secure_password

  validates :password, presence: true, length: {minimum: 6}

end
