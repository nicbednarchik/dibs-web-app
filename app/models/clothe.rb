class Clothe < ApplicationRecord
  belongs_to :user
  CONDITIONS = %w[new like_new good fair poor]

  has_many_attached :photos

  belongs_to :dibbed_by, class_name: "User", optional: true
  scope :available, -> { where(dibbed_by_id: nil) }

  def dibbed?
    dibbed_by_id.present?
  end

  validates :title, presence: true
  validates :item_type, presence: true
  validates :description, presence: true
  validates :size, presence: true
  validates :condition, presence: true
  validates :brand, presence: true
  validate :photos_count_within_limit

  private

  def photos_count_within_limit
    return unless photos.attached?
    if photos.attachments.size > 5
      errors.add(:photos, "too many (maximum is 5)")
    end
  end
end
