class CreateReflections < ActiveRecord::Migration[7.1]
  def change
    create_table :reflections do |t|
      t.date :date
      t.text :today_task
      t.text :review1
      t.text :review2
      t.text :summary
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
