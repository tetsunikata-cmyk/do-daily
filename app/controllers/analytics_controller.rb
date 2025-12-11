class AnalyticsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user

    # 直近7日分の日付
    @days = (6.days.ago.to_date..Date.current).to_a
    @labels = @days.map { |d| d.strftime("%m/%d") }

    total_habits = @user.habits.count

    if total_habits.zero?
      @rates = Array.new(@days.size, 0)
    else
      # ユーザーの習慣ログだけを対象にする
      logs_scope = HabitLog
                     .joins(:habit)
                     .where(habits: { user_id: @user.id })

      @rates = @days.map do |date|
        done_count = logs_scope.where(done_on: date).count
        ((done_count.to_f / total_habits) * 100).round
      end
    end
  end
end