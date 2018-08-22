require 'rails_helper'

RSpec.describe Range::SuggestionWeeklyRange, :type => :service do
  context "Date piece" do

    context "On same weekday of the beginning of the month" do
      it "must resolve date piece to match week range of transaction date if at beginning of month" do
        category = build(:category, :weekly, id: 735)
        transaction = build(:transaction, category: category, date: Date.strptime("01/08/2018", '%d/%m/%Y')) # wednesday and start of month
        range = Range::SuggestionWeeklyRange.new(transaction)

        expect(range.date_piece).to eq "2018-08-01-2018-08-07"
      end

      it "must resolve date piece to match week range of transaction date when not at beginning of month" do
        category = build(:category, :weekly, id: 735)
        transaction = build(:transaction, category: category, date: Date.strptime("08/08/2018", '%d/%m/%Y')) # some other wednesday
        range = Range::SuggestionWeeklyRange.new(transaction)

        expect(range.date_piece).to eq "2018-08-08-2018-08-14"
      end

    end

    context "On some weekday that is not the same of the beginning of the month" do

      it "must resolve date piece to match week range of transaction date rewinding if necessary" do
        category = build(:category, :weekly, id: 735)
        transaction = build(:transaction, category: category, date: Date.strptime("20/08/2018", '%d/%m/%Y')) # Monday. Month starts at wednesday
        range = Range::SuggestionWeeklyRange.new(transaction)

        expect(range.date_piece).to eq "2018-08-15-2018-08-21"
      end

    end

  end

  context "Suggestion String" do

    it "must resolve suggestion string" do
      category = build(:category, :weekly, id: 735)
      transaction = build(:transaction, category: category, date: Date.strptime("17/08/2018", '%d/%m/%Y'))

      range = Range::SuggestionWeeklyRange.new(transaction)

      expect(range.suggestion_string).to eq "2018-08-15-2018-08-21-category:735"
    end

  end

end
