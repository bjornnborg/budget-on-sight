class SetNegativeValueForDebitTransactions < ActiveRecord::Migration[5.0]
  def change
    Transaction.joins(:category)
      .where('amount > 0')
      .where(category: [category_type: :debit]).find_each do |transaction|
        transaction.update_attributes :amount => transaction.amount * -1
    end
  end
end
