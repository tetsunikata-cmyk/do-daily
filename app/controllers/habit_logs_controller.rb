class HabitLogsController < ApplicationController
  before_action :authenticate_user!

  def create
    habit = current_user.habits.find(params[:habit_id])
    habit.habit_logs.create!(done_on: Date.current)
    redirect_back fallback_location: goal_path
  end

  def destroy
    habit = current_user.habits.find(params[:habit_id])
    log = habit.habit_logs.find_by(done_on: Date.current)
    log&.destroy
    redirect_back fallback_location: goal_path
  end
end