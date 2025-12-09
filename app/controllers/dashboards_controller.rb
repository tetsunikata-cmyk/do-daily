class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user   = current_user
    @habits = current_user.habits.includes(:habit_logs)

    # 累積データ
    @total_habits         = @habits.count
    @total_logs           = HabitLog.joins(:habit).where(habits: { user_id: @user.id }).count
    @today_done_count     = HabitLog.joins(:habit).where(habits: { user_id: @user.id }, done_on: Date.current).count
    @longest_streak_value = @habits.map(&:current_streak).max || 0
  end
end