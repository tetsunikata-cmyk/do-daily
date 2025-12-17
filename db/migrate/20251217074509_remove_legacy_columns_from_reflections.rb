class RemoveLegacyColumnsFromReflections < ActiveRecord::Migration[7.1]
  def change
    remove_column :reflections, :date, :date
    remove_column :reflections, :today_task, :text
    remove_column :reflections, :review1, :text
    remove_column :reflections, :review2, :text
  end
end