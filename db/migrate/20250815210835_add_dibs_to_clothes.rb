class AddDibsToClothes < ActiveRecord::Migration[8.0]
  def change
    add_reference :clothes, :dibbed_by, foreign_key: { to_table: :users }, index: true
    add_column    :clothes, :dibbed_at, :datetime
  end
end
