class AddCategoryToHabits < ActiveRecord::Migration[7.1]
  def change
    add_column :habits, :category, :integer
  end
end
