class AddGoalToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :goal_title, :string
    add_column :users, :goal_reason, :text
  end
end
