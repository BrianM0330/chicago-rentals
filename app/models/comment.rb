class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :pin, counter_cache: true

  validates :body, length: { minimum: 2, maximum: 1000 }, allow_nil: true
end
