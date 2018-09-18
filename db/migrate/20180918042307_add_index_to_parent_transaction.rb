class AddIndexToParentTransaction < ActiveRecord::Migration[5.2]
  def change
    add_index :transactions, :installment_transaction_id
  end
end
