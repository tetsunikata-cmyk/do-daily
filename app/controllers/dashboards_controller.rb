class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user   = current_user
    @habits = current_user.habits.includes(:habit_logs)

    @total_habits         = @habits.count
    @total_logs           = HabitLog.joins(:habit).where(habits: { user_id: @user.id }).count
    @today_done_count     = HabitLog.joins(:habit).where(habits: { user_id: @user.id }, done_on: Date.current).count
    @longest_streak_value = @habits.map(&:current_streak).max || 0
  end

  def update
    if current_user.update(user_params)
      redirect_to mypage_path, notice: "Goal updated."
    else
      show
      render :show, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:goal_title, :goal_reason)
  end
end