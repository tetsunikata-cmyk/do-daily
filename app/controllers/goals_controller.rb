class GoalsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user   = current_user
    @habits = current_user.habits.order(:category, :id)
  end
end