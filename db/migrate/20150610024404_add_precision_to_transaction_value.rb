class AddPrecisionToTransactionValue < ActiveRecord::Migration[5.0]
  def change
    change_column :transactions, :amount, :decimal, precision: 11, scale: 2
  end
end
