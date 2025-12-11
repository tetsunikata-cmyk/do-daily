class ReflectionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @date = params[:date].present? ? Date.parse(params[:date]) : Date.current

    # その日の振り返りを1レコードにまとめる
    @reflection = @user.reflections.find_or_initialize_by(date: @date)

    # 開始日（最初の記録日 or 今日）
    start_date = @user.reflections.minimum(:date) || @date
    @days_from_start = (@date - start_date).to_i + 1
  end

  def create
    @reflection = current_user.reflections.find_or_initialize_by(
      date: reflection_params[:date]
    )
    @reflection.assign_attributes(reflection_params)
    if @reflection.save
      redirect_to reviews_path(date: @reflection.date), notice: "保存しました"
    else
      @user = current_user
      @date = @reflection.date
      start_date = @user.reflections.minimum(:date) || @date
      @days_from_start = (@date - start_date).to_i + 1
      render :index, status: :unprocessable_entity
    end
  end

  def update
    @reflection = current_user.reflections.find(params[:id])
    if @reflection.update(reflection_params)
      redirect_to reviews_path(date: @reflection.date), notice: "更新しました"
    else
      @user = current_user
      @date = @reflection.date
      start_date = @user.reflections.minimum(:date) || @date
      @days_from_start = (@date - start_date).to_i + 1
      render :index, status: :unprocessable_entity
    end
  end

  private

  def reflection_params
    params.require(:reflection).permit(
      :date, :today_task, :review1, :review2, :summary
    )
  end
end