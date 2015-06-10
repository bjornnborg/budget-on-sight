class AddIndexToCategoryType < ActiveRecord::Migration
  def change
    add_index :categories, :category_type
  end
end
