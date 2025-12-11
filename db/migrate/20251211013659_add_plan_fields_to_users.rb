class AddPlanFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :vision_text, :string, if_not_exists: true
    add_column :users, :roadmap_text, :text, if_not_exists: true
    add_column :users, :annual_schedule_text, :text, if_not_exists: true
  end
end
