class Habit < ApplicationRecord
  belongs_to :user
  has_many :habit_logs, dependent: :destroy

  enum category: { morning: 0, gap: 1, night: 2, other: 3 }, _default: :morning

  # 今日やったかどうか
  def done_today?
    habit_logs.exists?(done_on: Date.current)
  end

  # 連続日数
  def current_streak
    streak = 0
    day = Date.current

    loop do
      break unless habit_logs.exists?(done_on: day)
      streak += 1
      day -= 1
    end

    streak
  end
end