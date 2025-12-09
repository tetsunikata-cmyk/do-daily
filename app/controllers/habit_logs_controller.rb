class HabitLogsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_habit

  def create
    @habit.habit_logs.find_or_create_by(done_on: Date.current)
    redirect_to root_path
  end

  def destroy
    log = @habit.habit_logs.find_by(done_on: Date.current)
    log&.destroy
    redirect_to root_path
  end

  private

  def set_habit
    @habit = current_user.habits.find(params[:habit_id])
  end
end