class AddIndexToTransactionDate < ActiveRecord::Migration
  def change
    add_index :transactions, :date
  end
end
