class ReflectionsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    load_page_state
  end

  def update
    @user = current_user
    @selected_date = parse_date(params.dig(:reflection, :review_on) || params[:date])

    @reflection = @user.reflections.find_or_initialize_by(review_on: @selected_date)
    @reflection.assign_attributes(reflection_params.except(:review_on))

    if @reflection.save
      redirect_to reviews_path(date: @selected_date.to_s), notice: "振り返りを保存しました。"
    else
      load_page_state(selected_date: @selected_date, reflection: @reflection)
      render :show, status: :unprocessable_entity
    end
  end

  private

  def reflection_params
    params.require(:reflection).permit(:review_on, :challenge, :reflection1, :reflection2, :summary)
  end

  def parse_date(v)
    return Date.current if v.blank?
    Date.parse(v.to_s)
  rescue
    Date.current
  end

  def load_page_state(selected_date: nil, reflection: nil)
    @selected_date = selected_date || parse_date(params[:date])

    @reflection = reflection || @user.reflections.find_or_initialize_by(review_on: @selected_date)

    first_date = @user.reflections.minimum(:review_on) || @selected_date
    @day_count = (@selected_date - first_date).to_i + 1

    @q = params[:q].to_s.strip
    @search_results =
      if @q.present?
        q = "%#{@q}%"
        @user.reflections
             .where("challenge LIKE :q OR reflection1 LIKE :q OR reflection2 LIKE :q OR summary LIKE :q", q: q)
             .order(review_on: :desc)
      else
        []
      end

    @completion_stats = build_completion_stats(@user)
  end

  def build_completion_stats(user)
    today = Date.current
    (0..6).map do |i|
      date  = today - i
      total = user.habits.count
      done  = HabitLog.joins(:habit).where(habits: { user_id: user.id }, done_on: date).count
      rate  = total.zero? ? 0 : ((done.to_f / total) * 100).round
      { date: date, rate: rate }
    end.reverse
  end
end