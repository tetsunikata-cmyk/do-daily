class GoalsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user   = current_user
    @habits = @user.habits.order(:id) # 目標実現ページで表示する習慣
  end
end