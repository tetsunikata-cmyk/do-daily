class ScheduleEventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_habit
  before_action :set_event, only: [:update, :destroy]

 def create
  event = @habit.schedule_events.new(event_params.merge(user: current_user))

  if event.save
    redirect_back fallback_location: habit_schedule_day_path(@habit, date: event.starts_at.to_date),
                  notice: "予定を追加しました"
  else
    redirect_back fallback_location: habit_schedule_day_path(@habit, date: Date.current),
                  alert: event.errors.full_messages.first
  end
 end

def update
  if @event.update(event_params)
    redirect_back fallback_location: habit_schedule_day_path(@event.habit, date: @event.starts_at.to_date),
                  notice: "予定を更新しました"
  else
    redirect_back fallback_location: habit_schedule_day_path(@event.habit, date: @event.starts_at.to_date),
                  alert: @event.errors.full_messages.first
  end
end

def destroy
  date = @event.starts_at.to_date
  habit = @event.habit
  @event.destroy
  redirect_back fallback_location: habit_schedule_day_path(habit, date: date),
                notice: "予定を削除しました"
end

  private

  def set_habit
    @habit = current_user.habits.find(params[:habit_id])
  end

  def set_event
    @event = @habit.schedule_events.find(params[:id])
  end

  def event_params
    params.require(:schedule_event).permit(:title, :location, :starts_at, :ends_at)
  end
end