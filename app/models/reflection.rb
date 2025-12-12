class Reflection < ApplicationRecord
  belongs_to :user
  validates :review_on, presence: true
  validates :review_on, uniqueness: { scope: :user_id }
end