class User < ApplicationRecord
  has_secure_password

  has_many :pins,             dependent: :destroy
  has_many :comments,         dependent: :destroy
  has_many :bookmarks,        dependent: :destroy
  has_many :bookmarked_pins,  through: :bookmarks, source: :pin
  has_many :pin_flags,        dependent: :destroy
  has_many :sessions,         dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: true
end

