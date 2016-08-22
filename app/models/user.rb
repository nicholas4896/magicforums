class User < ApplicationRecord
  has_secure_password
  mount_uploader :image, ImageUploader

  has_many :posts
  has_many :topics
  has_many :comments
  has_many :votes

  extend FriendlyId
  friendly_id :username, use: [:slugged, :history]

  def should_generate_new_friendly_id?
    username_changed? || slug.blank?
  end

  #validates :email, presence: true
  #validates :password, presence: true

  enum role: [:user, :moderator, :admin]
end
