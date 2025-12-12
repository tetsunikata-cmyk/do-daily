class ReflectionsController < ApplicationController
  before_action :authenticate_user!

  def show
    @selected_date = params[:date].presence || Date.current
    @reflection = Reflection.find_or_initialize_by(
      user_id: current_user.id,
      review_on: @selected_date
    )

    @day_count = (Date.current - current_user.created_at.to_date).to_i + 1

    # 直近7日分の実行率（その日の完了習慣数 / 習慣総数）
    habits_count = current_user.habits.count

    @completion_stats = (0..6).map do |i|
      date = Date.current - i

      done_count =
        if habits_count == 0
          0
        else
          HabitLog.joins(:habit)
                  .where(habits: { user_id: current_user.id })
                  .where(done_on: date)
                  .distinct
                  .count(:habit_id)
        end

      rate = habits_count == 0 ? 0 : ((done_count.to_f / habits_count) * 100).round
      { date: date, rate: rate }
    end
  end

  def update
    @selected_date = params[:date].presence || Date.current
    @reflection = Reflection.find_or_initialize_by(
      user_id: current_user.id,
      review_on: @selected_date
    )

    if @reflection.update(reflection_params)
      redirect_to review_path(date: @selected_date), notice: "保存しました"
    else
      # showに必要な変数を再セット（失敗時に落ちないように）
      @day_count = (Date.current - current_user.created_at.to_date).to_i + 1

      habits_count = current_user.habits.count
      @completion_stats = (0..6).map do |i|
        date = Date.current - i

        done_count =
          if habits_count == 0
            0
          else
            HabitLog.joins(:habit)
                    .where(habits: { user_id: current_user.id })
                    .where(done_on: date)
                    .distinct
                    .count(:habit_id)
          end

        rate = habits_count == 0 ? 0 : ((done_count.to_f / habits_count) * 100).round
        { date: date, rate: rate }
      end

      render :show, status: :unprocessable_entity
    end
  end

  private

  def reflection_params
    params.require(:reflection).permit(:challenge, :reflection1, :reflection2, :summary)
  end
end