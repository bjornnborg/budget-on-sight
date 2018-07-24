class AddIndexToCategoryType < ActiveRecord::Migration[5.0]
  def change
    add_index :categories, :category_type
  end
end
