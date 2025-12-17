class HabitsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_habit, only: [:edit, :update, :destroy]

  # ぽちぽち一覧
  def index
    @habits = current_user.habits.includes(:habit_logs).order(created_at: :desc)
  end

  # 新規作成フォーム（必要なら）
  def new
    @habit = current_user.habits.new
  end

  # 作成
  def create
    @habit = current_user.habits.new(habit_params)

    if @habit.save
      redirect_to habits_path, notice: "習慣を追加しました。"
    else
      # indexに戻して一覧+エラー表示したいなら render :index でもOK
      render :new, status: :unprocessable_entity
    end
  end

  # 編集フォーム（必要なら）
  def edit
  end

  # 更新
  def update
    if @habit.update(habit_params)
      redirect_to habits_path, notice: "習慣を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # 削除
  def destroy
    @habit.destroy
    redirect_to habits_path, notice: "習慣を削除しました。"
  end

  private

  def set_habit
    @habit = current_user.habits.find(params[:id])
  end

  def habit_params
    params.require(:habit).permit(:title, :description, :category, :scheduled_time)
  end
end