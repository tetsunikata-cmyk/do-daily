class Habit < ApplicationRecord
  belongs_to :user
 
  has_many :habit_logs, dependent: :destroy

  def current_streak
    streak = 0
    day = Date.current

    loop do
      if habit_logs.exists?(done_on: day)
        streak += 1
        day -= 1
      else
        break
      end
    end

    streak
  end
end