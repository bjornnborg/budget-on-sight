require 'rails_helper'
include ActiveSupport::Testing::TimeHelpers

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

  context "Dates to filter" do

      it "must return a list of start/end dates" do
        travel_to (Time.new(2018, 8, 17))
        dates = Range::SuggestionWeeklyRange.dates_to_filter(Date.current)
        expect(dates.size).to eq 3
        expect(dates.map{|e| e.size}).to eq [2, 2, 2]
      end

      it "must list all dates until today if asking into the same month as today" do
        travel_to (Time.new(2018, 8, 17))
        dates = Range::SuggestionWeeklyRange.dates_to_filter(Date.current)

        expect(dates.size).to eq 3
      end

      it "must list all dates until end of month if asking into the other month than today" do
        travel_to (Time.new(2018, 8, 17))
        dates = Range::SuggestionWeeklyRange.dates_to_filter(Date.new(2018, 7, 1)) # daily suggestions of the past month

        expect(dates.size).to eq 5
        expect(dates.flatten.map{|e| e.month}.uniq.size).to eq 1
        expect(dates.flatten.map{|e| e.month}.uniq.first).to eq 7
      end  

  end

end
