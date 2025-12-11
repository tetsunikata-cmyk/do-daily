class HabitsController < ApplicationController
  before_action :authenticate_user!

  def create
    @habit = current_user.habits.new(habit_params)
    if @habit.save
      redirect_back fallback_location: goal_path, notice: "習慣を追加しました。"
    else
      redirect_back fallback_location: goal_path, alert: "習慣の追加に失敗しました。"
    end
  end

  def update
    @habit = current_user.habits.find(params[:id])
    if @habit.update(habit_params)
      redirect_back fallback_location: goal_path, notice: "習慣を更新しました。"
    else
      redirect_back fallback_location: goal_path, alert: "習慣の更新に失敗しました。"
    end
  end

  def destroy
    @habit = current_user.habits.find(params[:id])
    @habit.destroy
    redirect_back fallback_location: goal_path, notice: "習慣を削除しました。"
  end

  private

def habit_params
  params.require(:habit).permit(:title, :description, :category, :scheduled_time)
end
end