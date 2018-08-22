require 'rails_helper'

RSpec.describe HashService, :type => :service do

  context "Daily transactions" do
    it "must generate one hash to each transaction" do
      category = build(:category, :daily, id: 735)
      transaction_a = build(:transaction, category: category, date: Date.strptime("17/08/2018", '%d/%m/%Y'))
      transaction_b = build(:transaction, category: category, date: Date.strptime("18/08/2018", '%d/%m/%Y'))

      hash_a = HashService.compute_missing_hash(transaction_a)
      hash_b = HashService.compute_missing_hash(transaction_b)

      expect(hash_a).not_to eq hash_b
      expect(hash_a).to eq "6a5afc32018ad52d12fff0e97761e83e66151fd328dbc457e2f48294319cb96b"
      expect(hash_b).to eq "77b4d90be6ee5bdcf70a0a5ef98031f3b86449b7163c36ece5b09a168a9ad73b"
    end
  end

  context "Weekly transactions" do
    it "must generate one hash to all transactions on same week" do
      category = build(:category, :weekly, id: 735)

      transactions = (1..7).to_a.map do |day|
        build(:transaction, category: category, date: Date.strptime("#{day}/08/2018", '%d/%m/%Y'))
      end # from wednesday through tuesday of august/2018

      hashes = transactions.map{|t| HashService.compute_missing_hash(t)}

      expect(hashes.uniq.size).to eq 1
      expect(hashes.uniq.first).to eq "478a5a9e58dee8159190ee1fe16cf008fe75b87650bb08f61708f7d38f6639c0"
    end

    it "must generate different hashes to transactions on different weeks" do
      category = build(:category, :weekly, id: 735)

      transactions = (1..10).to_a.map do |day|
        build(:transaction, category: category, date: Date.strptime("#{day}/08/2018", '%d/%m/%Y'))
      end # from wednesday through friday of the other week of august/2018. After 07/08 we are on other week

      hashes = transactions.map{|t| HashService.compute_missing_hash(t)}

      expect(hashes.uniq.size).to eq 2
      expect(hashes.uniq.first).to eq "478a5a9e58dee8159190ee1fe16cf008fe75b87650bb08f61708f7d38f6639c0"
      expect(hashes.uniq.last).to eq "e09073f61c81888af8b0da7bd3195bf826eb354a2960dabf6f8c2909cfaad54e"
    end

  end

  context "Monthly transactions" do
    it "must generate one hash to all transactions on same month" do
      category = build(:category, :monthly, id: 735)

      transactions = (1..31).to_a.map do |day|
        build(:transaction, category: category, date: Date.strptime("#{day}/08/2018", '%d/%m/%Y'))
      end # from wednesday through tuesday of august/2018

      hashes = transactions.map{|t| HashService.compute_missing_hash(t)}

      expect(hashes.uniq.size).to eq 1
      expect(hashes.uniq.first).to eq "ae0d1b1145b451a012bc22e689122f43d67f5e33736d946322766074f34f6446"
    end
  end

  context "Oftenly transactions" do
    it "must not generate hash to a transaction" do
      category = build(:category, :oftenly, id: 735)

      transaction = build(:transaction, category: category, date: Date.strptime("17/08/2018", '%d/%m/%Y'))
      hash = HashService.compute_missing_hash(transaction)

      expect(hash).to be_nil
    end
  end

end
