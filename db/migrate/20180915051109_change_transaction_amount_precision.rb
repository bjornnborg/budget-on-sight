class ChangeTransactionAmountPrecision < ActiveRecord::Migration[5.2]
  def change
    change_column(:transactions, :amount, :decimal, precision: 15, scale: 6)
  end
end
