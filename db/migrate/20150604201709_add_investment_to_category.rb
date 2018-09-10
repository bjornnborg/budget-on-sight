class AddInvestmentToCategory < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :investment, :boolean, :default => false
  end
end
