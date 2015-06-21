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
end
