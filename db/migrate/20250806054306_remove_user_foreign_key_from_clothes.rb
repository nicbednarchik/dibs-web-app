class RemoveUserForeignKeyFromClothes < ActiveRecord::Migration[8.0]
  def up
    remove_foreign_key :clothes, :users
  end

  def down
    add_foreign_key :clothes, :users
  end
end
