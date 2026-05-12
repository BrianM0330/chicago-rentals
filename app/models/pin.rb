class Pin < ApplicationRecord
  KINDS = %w[rent discussion].freeze

  belongs_to :user
  belongs_to :locality
  belongs_to :building, optional: true

  has_many :comments,  dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :pin_flags, dependent: :destroy

  before_validation { self.slug = SecureRandom.urlsafe_base64(6) if slug.blank? }
  before_validation { self.hood = locality&.name if hood.blank? }

  validates :kind, inclusion: { in: KINDS }
  validates :slug, presence: true, uniqueness: true
  validates :latitude, :longitude, :hood, :reported_on, presence: true
  validates :latitude,  numericality: { greater_than_or_equal_to:  -90, less_than_or_equal_to:  90 }
  validates :longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
  validates :rent_cents, presence: true, numericality: { greater_than: 0 }, if: -> { kind == "rent" }
  validates :bedrooms, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
