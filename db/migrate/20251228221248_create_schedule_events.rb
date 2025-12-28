class CreateScheduleEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :schedule_events do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.datetime :starts_at
      t.datetime :ends_at
      t.text :notes

      t.timestamps
    end
  end
end
