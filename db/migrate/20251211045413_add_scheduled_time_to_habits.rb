class AddScheduledTimeToHabits < ActiveRecord::Migration[7.1]
  def change
    add_column :habits, :scheduled_time, :time
  end
end
