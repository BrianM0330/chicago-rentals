class Building < ApplicationRecord
  belongs_to :locality

  has_many :pins, dependent: :nullify

  validates :city, :state, presence: true
  validates :street_number, :street, :postal_code, presence: true
  validates :latitude, :longitude, presence: true
  validates :latitude,  numericality: { greater_than_or_equal_to:  -90, less_than_or_equal_to:  90 }
  validates :longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
end
