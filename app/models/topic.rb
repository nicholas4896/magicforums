class Topic < ApplicationRecord
  mount_uploader :image, ImageUploader
  paginates_per 3

  has_many :posts
  validates :title, length: { minimum: 5 }, presence: true
  validates :description, length: { minimum: 5 }, presence: true
  belongs_to :user

  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]

  def should_generate_new_friendly_id?
    title_changed? || slug.blank?
  end

end
