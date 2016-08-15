class Comment < ApplicationRecord
  mount_uploader :image, ImageUploader
  belongs_to :post
  belongs_to :user
  validates :body, length: { minimum: 5 }, presence: true
  paginates_per 3
  #max_paginates_per 3

end
