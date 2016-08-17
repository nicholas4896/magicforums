class User < ApplicationRecord
  has_secure_password

  mount_uploader :image, ImageUploader
  has_many :posts
  has_many :topics
  has_many :comments

  #validates :email, presence: true
  #validates :password, presence: true

  enum role: [:user, :moderator, :admin]
end
