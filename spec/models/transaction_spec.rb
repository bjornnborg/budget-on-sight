require 'rails_helper'

RSpec.describe Transaction, :type => :model do
  context "Negative and positive amounts" do
    it "must have negative amount if has a debit category" do
      category = build(:category)
      transaction = Transaction.new
      transaction.category = category
      transaction.amount = 100
      expect(transaction.amount).to eq -100
    end

    it "must keep negative amount if has a debit category" do
      category = build(:category)
      transaction = Transaction.new
      transaction.category = category
      transaction.amount = -100
      expect(transaction.amount).to eq -100
    end    

    it "must have positive amount if has a credit category" do
      category = build(:category, :credit)
      transaction = Transaction.new
      transaction.category = category
      transaction.amount = -100
      expect(transaction.amount).to eq 100
    end

    it "must keep positive amount if has a credit category" do
      category = build(:category, :credit)
      transaction = Transaction.new
      transaction.category = category
      transaction.amount = 100
      expect(transaction.amount).to eq 100
    end
  end
end
