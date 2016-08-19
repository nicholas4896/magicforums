class Comment < ApplicationRecord
  mount_uploader :image, ImageUploader

  has_many :votes
  belongs_to :post
  belongs_to :user
  validates :body, length: { minimum: 5 }, presence: true

  paginates_per 3

  def total_votes
    votes.pluck(:value).sum
  end

end
