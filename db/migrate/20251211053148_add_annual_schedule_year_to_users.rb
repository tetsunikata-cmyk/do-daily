class AddAnnualScheduleYearToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :annual_schedule_year, :integer, default: Date.current.year
  end
end
