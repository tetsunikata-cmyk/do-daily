# app/controllers/reflections_controller.rb

class ReflectionsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user

    # ---- ① 表示する日付を決定（?date があればそれ、なければ今日） ----
    @selected_date = parse_date(params[:date]) || Date.current

    # その日の振り返りレコードを取得（なければ new）
    @reflection = @user.reflections.find_or_initialize_by(review_on: @selected_date)

    # 「今日は開始◯日目」
    first_date   = @user.reflections.minimum(:review_on) || @selected_date
    @day_count   = (@selected_date - first_date).to_i + 1

    # ---- ③ キーワード検索（保存済みレコードの中から） ----
    @query = params[:query].presence
    if @query
      q = "%#{@query}%"
      @search_results = @user.reflections
                            .where(
                              "challenge   LIKE :q OR " \
                              "reflection1 LIKE :q OR " \
                              "reflection2 LIKE :q OR " \
                              "summary     LIKE :q",
                              q: q
                            )
                            .order(review_on: :desc)
    else
      @search_results = []
    end

    # ---- ④ 直近7日間の実行率（グラフ用データ） ----
    @completion_stats = build_completion_stats(@user)
  end

  # フォームの保存（新規/更新どっちもここ）
  def update
    @user = current_user

    selected_date = parse_date(reflection_params[:review_on]) || Date.current

    @reflection =
      @user.reflections.find_or_initialize_by(review_on: selected_date)

    @reflection.assign_attributes(reflection_params.except(:review_on))

    if @reflection.save
      # ← 保存後はその日付でもう一度 show へ
      redirect_to reviews_path(date: selected_date.to_s),
                  notice: "振り返りを保存しました。"
    else
      # バリデーションエラー時も show を再表示
      @selected_date = selected_date
      first_date     = @user.reflections.minimum(:review_on) || @selected_date
      @day_count     = (@selected_date - first_date).to_i + 1
      @query         = params[:query].presence
      @search_results   = []
      @completion_stats = build_completion_stats(@user)

      render :show, status: :unprocessable_entity
    end
  end

  private

  # "2025-12-10" みたいな文字列を Date に
  def parse_date(str)
    return nil if str.blank?
    Date.parse(str) rescue nil
  end

  def reflection_params
    params.require(:reflection)
          .permit(:review_on, :challenge, :reflection1, :reflection2, :summary)
  end

  # 直近7日間の実行率（0〜100）を返す
  def build_completion_stats(user)
    today = Date.current

    (0..6).map do |i|
      date  = today - i
      total = user.habits.count
      done  = HabitLog.joins(:habit)
                      .where(habits: { user_id: user.id }, done_on: date)
                      .count

      rate = total.zero? ? 0 : ((done.to_f / total) * 100).round
      { date: date, rate: rate }
    end.reverse
  end
end