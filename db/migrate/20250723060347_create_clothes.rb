class CreateClothes < ActiveRecord::Migration[8.0]
  def change
    create_table :clothes do |t|
      t.string :img
      t.string :item_type
      t.string :title
      t.string :description
      t.string :size
      t.string :condition
      t.string :brand
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
