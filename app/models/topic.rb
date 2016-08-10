class Topic < ApplicationRecord
  mount_uploader :image, ImageUploader

  has_many :posts
end
