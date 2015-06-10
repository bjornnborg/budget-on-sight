class AddPrecisionToCategoryValue < ActiveRecord::Migration
  def change
    change_column :categories, :value, :decimal, precision: 11, scale: 2
  end
end
