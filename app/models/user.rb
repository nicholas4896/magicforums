class User < ApplicationRecord
  has_secure_password

  mount_uploader :image, ImageUploader
  has_many :posts
  has_many :topics
  has_many :comments

  enum role: [:user, :moderator, :admin]
end
