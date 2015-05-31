class RenameActiveToDisabledInCategory < ActiveRecord::Migration
  def change
    rename_column :categories, :active, :disabled
  end
end
