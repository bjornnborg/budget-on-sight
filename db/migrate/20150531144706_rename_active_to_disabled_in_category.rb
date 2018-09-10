class RenameActiveToDisabledInCategory < ActiveRecord::Migration[5.0]
  def change
    rename_column :categories, :active, :disabled
  end
end
