class RoadmapsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(roadmap_params)
      redirect_to roadmap_path, notice: "更新しました"
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def roadmap_params
    params.require(:user).permit(:roadmap_text, :annual_schedule_text)
  end
end