class SchedulesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_habit

  def month
    @view = :month
    @selected_date = parse_date(params[:date])
    @base_date = @selected_date

    from = @base_date.beginning_of_month.beginning_of_week(:monday)
    to   = @base_date.end_of_month.end_of_week(:monday)

    @days = (from..to).to_a

    @events = @habit.schedule_events
                    .where(starts_at: from.beginning_of_day..to.end_of_day)
                    .order(:starts_at)

    @events_by_day = @events.group_by { |e| e.starts_at.to_date }
  end

  def week
    @view = :week
    @selected_date = parse_date(params[:date])
    @base_date = @selected_date

    from = @base_date.beginning_of_week(:monday)
    to   = @base_date.end_of_week(:monday)

    @days = (from..to).to_a

    @events = @habit.schedule_events
                    .where(starts_at: from.beginning_of_day..to.end_of_day)
                    .order(:starts_at)

    @events_by_day = @events.group_by { |e| e.starts_at.to_date }
  end

  def day
    @view = :day
    @selected_date = parse_date(params[:date])

    from = @selected_date.beginning_of_day
    to   = @selected_date.end_of_day

    @events = @habit.schedule_events
                    .where(starts_at: from..to)
                    .order(:starts_at)

    @new_event = @habit.schedule_events.new(
      user: current_user,
      starts_at: @selected_date.change(hour: 9, min: 0),
      ends_at:   @selected_date.change(hour: 10, min: 0)
    )
  end

  private

  def set_habit
    @habit = current_user.habits.find(params[:habit_id])
  end

  def parse_date(v)
    return Date.current if v.blank?
    Date.parse(v.to_s)
  rescue ArgumentError
    Date.current
  end
end