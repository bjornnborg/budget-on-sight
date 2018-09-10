class ChangeTypeToTransactionType < ActiveRecord::Migration[5.0]
  def change
    rename_column :categories, :type, :category_type
  end
end
