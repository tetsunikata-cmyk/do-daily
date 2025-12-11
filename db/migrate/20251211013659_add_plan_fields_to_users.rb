class AddPlanFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :vision_text, :string
    add_column :users, :roadmap_text, :text
    add_column :users, :annual_schedule_text, :text
  end
end
