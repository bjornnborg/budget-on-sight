class AddNotNullToCategoryFields < ActiveRecord::Migration[5.0]
  def change
    change_column_null :categories, :description, false
    change_column_null :categories, :category_type, false
    change_column_null :categories, :frequency, false
  end
end
