require 'rails_helper'

RSpec.describe Transaction, :type => :model do
  context "Debit & Credit" do
    it "must have negative value if has a debit category" do
        category = build(:category)
        transaction = Transaction.new
        transaction.category = category
        transaction.amount = 100
        expect(transaction.amount).to eq -100
    end
  end
end

