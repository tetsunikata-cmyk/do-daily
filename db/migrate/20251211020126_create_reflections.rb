class CreateReflections < ActiveRecord::Migration[7.1]
  def change
    create_table :reflections do |t|
      t.references :user, null: false, foreign_key: true

      t.date :review_on, null: false  # ← 振り返りの日付（キー）

      t.text :challenge               # 今日の課題
      t.text :reflection1             # 振り返り①
      t.text :reflection2             # 振り返り②
      t.text :summary                 # 今日の振り返り

      t.timestamps
    end
  end
end