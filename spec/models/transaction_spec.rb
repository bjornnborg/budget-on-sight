require 'rails_helper'

RSpec.describe Transaction, :type => :model do

  context "Normalize amount" do
    it "must change to negative amount if has a debit category" do
      transaction = build(:transaction, {amount: 100})
      expect(transaction.normalized_amount).to eq -100
    end

    it "must keep negative amount if has a debit category" do
      transaction = build(:transaction, {amount: -100})
      expect(transaction.normalized_amount).to eq -100
    end    

    it "must change to positive amount if has a credit category" do
      transaction = build(:transaction, :credit, {amount: -100})
      expect(transaction.normalized_amount).to eq 100
    end

    it "must keep positive amount if has a credit category" do
      transaction = build(:transaction, :credit, {amount: 100})
      expect(transaction.normalized_amount).to eq 100
    end
  end

  context "Installments" do
    it "must generate as many transactions as installments" do
      transactions = Transaction.new() / 4
      expect(transactions.size).to eq 4
    end

    it "must divide transaction value among new transactions" do
      transactions = Transaction.new(amount: 300.90) / 4      
      expect(transactions.map{|t| t.amount}.first).to eq BigDecimal.new("75.225")
    end

    it "must skip 1 month on each transaction date after the first" do
      transaction_date = Date.strptime("2018-01-01", "%Y-%m-%d")
      transactions = Transaction.new(date: transaction_date, amount: 300) / 3
      
      expect(transactions.first.date).to eq Date.strptime("2018-01-01", "%Y-%m-%d")
      expect(transactions.second.date).to eq Date.strptime("2018-02-01", "%Y-%m-%d")
      expect(transactions.third.date).to eq Date.strptime("2018-03-01", "%Y-%m-%d")
    end

    it "must generate transactions for all months" do
      transaction_date = Date.strptime("2018-01-30", "%Y-%m-%d") # problems in Frebruary?
      transactions = Transaction.new(date: transaction_date, amount: 300) / 3
      
      expect(transactions.first.date).to eq Date.strptime("2018-01-30", "%Y-%m-%d")
      expect(transactions.second.date).to eq Date.strptime("2018-02-28", "%Y-%m-%d")
      expect(transactions.third.date).to eq Date.strptime("2018-03-28", "%Y-%m-%d")
    end

    it "must generate transactions for all months if year changes" do
      transaction_date = Date.strptime("2018-12-30", "%Y-%m-%d") # problems in Frebruary?
      transactions = Transaction.new(date: transaction_date, amount: 300) / 3
      
      expect(transactions.first.date).to eq Date.strptime("2018-12-30", "%Y-%m-%d")
      expect(transactions.second.date).to eq Date.strptime("2019-01-30", "%Y-%m-%d")
      expect(transactions.third.date).to eq Date.strptime("2019-02-28", "%Y-%m-%d")
    end

    it "must put installment number on payee description" do
      transactions = Transaction.new(payee: "Cool Store", date: Time.now, amount: 300) / 3
      
      expect(transactions.first.payee).to eq "Cool Store (1/3)"
      expect(transactions.second.payee).to eq "Cool Store (2/3)"
      expect(transactions.third.payee).to eq "Cool Store (3/3)"
    end

    it "must put installment number on payee description even if empty" do
      transactions = Transaction.new(date: Time.now, amount: 300) / 3
      
      expect(transactions.first.payee).to eq "(1/3)"
      expect(transactions.second.payee).to eq "(2/3)"
      expect(transactions.third.payee).to eq "(3/3)"
    end
  end
end
