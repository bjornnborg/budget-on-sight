class AddInstallmentNumberToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :installment_number, :integer, default: 1
  end
end
