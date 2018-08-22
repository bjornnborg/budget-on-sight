require 'rails_helper'

RSpec.describe Range::SuggestionDailyRange, :type => :service do
  context "Basic" do
    it "must resolve date piece to match begining exactly given day" do
      category = build(:category, :daily, id: 735)
      transaction = build(:transaction, category: category, date: Date.strptime("17/08/2018", '%d/%m/%Y'))

      range = Range::SuggestionDailyRange.new(transaction)

      expect(range.date_piece).to eq "2018-08-17"
    end

    it "must resolve suggestion string" do
      category = build(:category, :daily, id: 735)
      transaction = build(:transaction, category: category, date: Date.strptime("17/08/2018", '%d/%m/%Y'))

      range = Range::SuggestionDailyRange.new(transaction)

      expect(range.suggestion_string).to eq "2018-08-17-category:735"
    end

  end

end
