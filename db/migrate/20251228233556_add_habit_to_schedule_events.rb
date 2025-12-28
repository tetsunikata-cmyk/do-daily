class AddHabitToScheduleEvents < ActiveRecord::Migration[7.1]
  def change
    add_reference :schedule_events, :habit, null: false, foreign_key: true
  end
end
