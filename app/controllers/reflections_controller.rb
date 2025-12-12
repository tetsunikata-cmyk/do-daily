# app/controllers/reflections_controller.rb
class ReflectionsController < ApplicationController
  before_action :authenticate_user!

  # 振り返りの記入（編集ページ）
  def show
    @user = current_user
    @selected_date = parse_date(params[:date])

    @reflection = @user.reflections.find_or_initialize_by(review_on: @selected_date)

    first_date = @user.reflections.minimum(:review_on) || @selected_date
    @day_count = (@selected_date - first_date).to_i + 1
  end

  # 保存（その日付の1件だけ更新/作成）
  def update
    @user = current_user
    @selected_date = parse_date(params.dig(:reflection, :review_on) || params[:date])

    @reflection = @user.reflections.find_or_initialize_by(review_on: @selected_date)
    @reflection.assign_attributes(reflection_params.except(:review_on))

    if @reflection.save
      redirect_to reviews_path(date: @selected_date.to_s), notice: "振り返りを保存しました。"
    else
      first_date = @user.reflections.minimum(:review_on) || @selected_date
      @day_count = (@selected_date - first_date).to_i + 1
      render :show, status: :unprocessable_entity
    end
  end

  # 振り返り検索（編集不可）
  def search
    @user = current_user

    @selected_date = parse_date(params[:date])
    @q = params[:q].to_s.strip

    # 「検索した時だけ結果を出す」
    @searched = params[:date].present? || @q.present?

    @results =
      if !@searched
        []
      elsif params[:date].present?
        # 日付検索（その日の1件）
        r = @user.reflections.find_by(review_on: @selected_date)
        r ? [r] : []
      else
        # キーワード検索
        like = "%#{@q}%"
        @user.reflections
             .where("challenge LIKE :q OR reflection1 LIKE :q OR reflection2 LIKE :q OR summary LIKE :q", q: like)
             .order(review_on: :desc)
      end

    # グラフは検索ページだけに表示
    @completion_stats = build_completion_stats(@user)
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