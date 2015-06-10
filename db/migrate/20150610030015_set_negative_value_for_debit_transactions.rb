class SetNegativeValueForDebitTransactions < ActiveRecord::Migration
  def change
    Transaction.joins(:category)
        .where('amount > ?', 0)
        .where('categories.category_type' => :debit).all.each do |transaction|
            transaction.update_attributes :amount => transaction.amount * -1
    end
  end
end
