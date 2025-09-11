class User < ApplicationRecord
  has_one_attached :avatar
  attr_accessor :remove_avatar
  before_save :purge_avatar_if_requested

  private
  def purge_avatar_if_requested
    avatar.purge if ActiveModel::Type::Boolean.new.cast(remove_avatar)
  end

  has_many :clothes, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username,
    presence: true,
    uniqueness: { case_sensitive: false },
    length: { minimum: 3, maximum: 20 },
    format: { with: /\A[a-zA-Z0-9_]+\z/, message: "only letters, numbers, and underscores" }

  def display_name
    username.presence || email
  end

  def first_name_or_fallback
    first_name.presence || username.presence || email
  end
end
