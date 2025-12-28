class ScheduleEventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:update, :destroy]

  def create
    event = current_user.schedule_events.new(event_params)
    if event.save
      redirect_back fallback_location: schedule_path, notice: "予定を追加しました"
    else
      redirect_back fallback_location: schedule_path, alert: event.errors.full_messages.first
    end
  end

  def update
    if @event.update(event_params)
      redirect_back fallback_location: schedule_path, notice: "予定を更新しました"
    else
      redirect_back fallback_location: schedule_path, alert: @event.errors.full_messages.first
    end
  end

  def destroy
    @event.destroy
    redirect_back fallback_location: schedule_path, notice: "予定を削除しました"
  end

  private

  def set_event
    @event = current_user.schedule_events.find(params[:id])
  end

  def event_params
    params.require(:schedule_event).permit(:title, :location, :starts_at, :ends_at)
  end
end