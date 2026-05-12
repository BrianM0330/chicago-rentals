class Locality < ApplicationRecord
  has_many :buildings
  has_many :pins

  before_validation :generate_slug

  validates :name, :city, :state, presence: true
  validates :slug, presence: true, uniqueness: true

  private

  def generate_slug
    return if name.blank? || city.blank?
    self.slug ||= "#{name}-#{city}".parameterize
  end
end
