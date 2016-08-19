class Post < ApplicationRecord
  mount_uploader :image, ImageUploader
  paginates_per 3

  has_many :comments
  belongs_to :topic
  belongs_to :user
  validates :title, length: { minimum: 5 }, presence: true
  validates :body, length: { minimum: 5 }, presence: true

  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]

  def should_generate_new_friendly_id?
    title_changed? || slug.blank?
  end

end
