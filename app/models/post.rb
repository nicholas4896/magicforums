class Post < ApplicationRecord
  mount_uploader :image, ImageUploader
  has_many :comments
  belongs_to :topic
  belongs_to :user
  validates :title, length: { minimum: 5 }, presence: true
  validates :body, length: { minimum: 5 }, presence: true
  paginates_per 3

end
