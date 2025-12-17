class AddReviewOnToReflections < ActiveRecord::Migration[7.1]
  def change
    return if column_exists?(:reflections, :review_on)

    add_column :reflections, :review_on, :date
  end
end