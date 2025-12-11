class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user   = current_user
    @habits = current_user.habits.includes(:habit_logs)

    logs_scope = HabitLog.joins(:habit).where(habits: { user_id: @user.id })

    @total_habits         = @habits.count
    @total_logs           = logs_scope.count
    @today_done_count     = logs_scope.where(done_on: Date.current).count
    @longest_streak_value = @habits.map(&:current_streak).max || 0

    # ▼ グラフ用データ（直近7日分）
    start_date = 6.days.ago.to_date
    end_date   = Date.current

    @chart_labels = (start_date..end_date).map { |d| d.strftime("%m/%d") }
    @chart_data   = (start_date..end_date).map do |d|
      logs_scope.where(done_on: d).count
    end
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

    private

  private

  def user_params
    params.require(:user).permit(
    :goal_title,
    :goal_reason,
    :goal_image,
    :vision_text
    )
  end
end