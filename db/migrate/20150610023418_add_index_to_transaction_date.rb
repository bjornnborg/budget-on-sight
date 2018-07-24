class AddIndexToTransactionDate < ActiveRecord::Migration[5.0]
  def change
    add_index :transactions, :date
  end
end
