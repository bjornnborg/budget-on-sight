class AddInvestmentToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :investment, :boolean, :default => false
  end
end
