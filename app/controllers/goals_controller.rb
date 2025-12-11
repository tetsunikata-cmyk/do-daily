# app/controllers/goals_controller.rb
class GoalsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    ensure_fixed_review_habits!

    habits = @user.habits.order(:category, :id)
    @grouped_habits = habits.group_by(&:category)
  end

  private

  def ensure_fixed_review_habits!
    fixed = [
      { category: "morning", title: "今日の目標を書き出す（link①）" },
      { category: "morning", title: "朝振り返り（link②）" },
      { category: "night",   title: "夜振り返り（link③）" },
      { category: "night",   title: "今日の振り返り（link④）" }
    ]

    fixed.each do |attrs|
      current_user.habits.find_or_create_by!(
        category: attrs[:category],
        title:    attrs[:title]
      )
    end
  end
end