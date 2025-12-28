class SchedulesController < ApplicationController
  before_action :authenticate_user!

  def month
    @view = :month
    @base_date = parse_date(params[:date]) # その月の基準日
    from = @base_date.beginning_of_month.beginning_of_week(:monday)
    to   = @base_date.end_of_month.end_of_week(:monday)

    @days = (from..to).to_a

    @events = current_user.schedule_events
                          .where(starts_at: from.beginning_of_day..to.end_of_day)
                          .order(:starts_at)
    @events_by_day = @events.group_by { |e| e.starts_at.to_date }
  end

  def week
    @view = :week
    @base_date = parse_date(params[:date])
    from = @base_date.beginning_of_week(:monday)
    to   = @base_date.end_of_week(:monday)

    @days = (from..to).to_a

    @events = current_user.schedule_events
                          .where(starts_at: from.beginning_of_day..to.end_of_day)
                          .order(:starts_at)
    @events_by_day = @events.group_by { |e| e.starts_at.to_date }
  end

  def day
    @view = :day
    @selected_date = parse_date(params[:date])
    from = @selected_date.beginning_of_day
    to   = @selected_date.end_of_day

    @events = current_user.schedule_events
                          .where(starts_at: from..to)
                          .order(:starts_at)

    @new_event = current_user.schedule_events.new(
      starts_at: @selected_date.change(hour: 9, min: 0),
      ends_at:   @selected_date.change(hour: 10, min: 0)
    )
  end

  private

  def parse_date(v)
    return Date.current if v.blank?
    Date.parse(v.to_s)
  rescue
    Date.current
  end
end