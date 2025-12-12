class FixReviewOnForReflections < ActiveRecord::Migration[7.1]
  def change
    change_column_null :reflections, :review_on, false

    # 既にあれば作らない（MySQLでduplicate key name回避）
    unless index_exists?(:reflections, [:user_id, :review_on], name: "index_reflections_on_user_id_and_review_on")
      add_index :reflections, [:user_id, :review_on],
                unique: true,
                name: "index_reflections_on_user_id_and_review_on"
    end
  end
end