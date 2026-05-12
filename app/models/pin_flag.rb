class PinFlag < ApplicationRecord
  belongs_to :user
  belongs_to :pin, counter_cache: :flags_count

  validates :reason, presence: true
  validates :user_id, uniqueness: { scope: [:pin_id, :reason] }
end
