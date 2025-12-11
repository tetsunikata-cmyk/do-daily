class AddFieldsToReflections < ActiveRecord::Migration[7.1]
  def change
    # すでにカラムがある場合はスキップしてエラーを避ける

    unless column_exists?(:reflections, :challenge)
      add_column :reflections, :challenge, :text
    end

    unless column_exists?(:reflections, :reflection1)
      add_column :reflections, :reflection1, :text
    end

    unless column_exists?(:reflections, :reflection2)
      add_column :reflections, :reflection2, :text
    end

    unless column_exists?(:reflections, :summary)
      add_column :reflections, :summary, :text
    end
  end
end