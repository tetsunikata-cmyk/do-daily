class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def index
    @date = params[:date].presence
    @q    = params[:q].to_s.strip

    @reflections = Reflection.where(user_id: current_user.id)

    if @date.present?
      @reflections = @reflections.where(review_on: @date)
    end

    if @q.present?
      like = "%#{@q}%"
      @reflections = @reflections.where(
        "challenge LIKE ? OR reflection1 LIKE ? OR reflection2 LIKE ? OR summary LIKE ?",
        like, like, like, like
      )
    end

    @reflections = @reflections.order(review_on: :desc)
  end
end