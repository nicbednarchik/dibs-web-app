class EnforceUserOnClothes < ActiveRecord::Migration[8.0]
  def change
    change_column_null :clothes, :user_id, false
  end
end
