class AddPrecisionToTransactionValue < ActiveRecord::Migration
  def change
    change_column :transactions, :amount, :decimal, precision: 11, scale: 2
  end
end
