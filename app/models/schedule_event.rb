class ScheduleEvent < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, length: { maximum: 60 }
  validates :location, presence: true, length: { maximum: 60 }
  validates :starts_at, presence: true

  validate :ends_after_starts

  private

  def ends_after_starts
    return if ends_at.blank? || starts_at.blank?
    errors.add(:ends_at, "は開始より後にしてください") if ends_at <= starts_at
  end
end