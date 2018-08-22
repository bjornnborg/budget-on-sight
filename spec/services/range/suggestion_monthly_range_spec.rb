require 'rails_helper'

RSpec.describe Range::SuggestionMonthlyRange, :type => :service do
  context "Basic" do
    it "must resolve date piece to match begining and end of month" do
      category = build(:category, :monthly, id: 735)
      transaction = build(:transaction, category: category, date: Date.strptime("17/08/2018", '%d/%m/%Y'))

      range = Range::SuggestionMonthlyRange.new(transaction)

      expect(range.date_piece).to eq "2018-08-01-2018-08-31"
    end

    it "must resolve suggestion string" do
      category = build(:category, :monthly, id: 735)
      transaction = build(:transaction, category: category, date: Date.strptime("17/08/2018", '%d/%m/%Y'))

      range = Range::SuggestionMonthlyRange.new(transaction)

      expect(range.suggestion_string).to eq "2018-08-01-2018-08-31-category:735"
    end


  end
end
