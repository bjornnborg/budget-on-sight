class AddPrecisionToCategoryValue < ActiveRecord::Migration[5.0]
  def change
    change_column :categories, :value, :decimal, precision: 11, scale: 2
  end
end
