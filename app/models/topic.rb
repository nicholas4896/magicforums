class Topic < ApplicationRecord
  mount_uploader :image, ImageUploader
  has_many :posts
  validates :title, length: { minimum: 5 }, presence: true
  validates :description, length: { minimum: 10 }, presence: true
  paginates_per 3
  #max_paginates_per 3
  belongs_to :user

end
