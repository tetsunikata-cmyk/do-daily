class RemoveLegacyColumnsFromReflections < ActiveRecord::Migration[7.1]
  def change
    remove_column :reflections, :date, :date if column_exists?(:reflections, :date)
  end
end