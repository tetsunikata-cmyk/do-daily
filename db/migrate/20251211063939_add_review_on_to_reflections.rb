class AddReviewOnToReflections < ActiveRecord::Migration[7.1]
  def change
    # 既にカラムがあれば二重追加で落ちるので、保険で条件付きにしてもOKだけど
    # 普通はこれで十分
    add_column :reflections, :review_on, :date

    # 同じ user が同じ日付を複数持たない想定なのでインデックス付けとくと吉
    add_index :reflections, [:user_id, :review_on], unique: true
  end
end