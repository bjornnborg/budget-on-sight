class AddTransactionIdToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :installment_transaction_id, :integer
    add_foreign_key :transactions, :transactions, column: :installment_transaction_id, primary_key: :id
  end
end
