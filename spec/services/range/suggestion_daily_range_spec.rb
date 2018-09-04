require 'rails_helper'
include ActiveSupport::Testing::TimeHelpers

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

  context "Dates to filter" do

    it "must return a list of start/end dates" do
      travel_to (Time.new(2018, 8, 03))
      dates = Range::SuggestionDailyRange.dates_to_filter(Date.current)
      expect(dates.size).to eq 3
      expect(dates.map{|e| e.size}).to eq [2, 2, 2]
    end

    it "must list all dates until today if asking into the same month as today" do
      travel_to (Time.new(2018, 8, 17))
      dates = Range::SuggestionDailyRange.dates_to_filter(Date.current)

      expect(dates.size).to eq 17
    end

    it "must list all dates until end of month if asking into the other month than today" do
      travel_to (Time.new(2018, 8, 17))
      dates = Range::SuggestionDailyRange.dates_to_filter(Date.new(2018, 7, 1)) # daily suggestions of the past month

      expect(dates.size).to eq 31
      expect(dates.flatten.map{|e| e.month}.uniq.size).to eq 1
      expect(dates.flatten.map{|e| e.month}.uniq.first).to eq 7
    end

  end

end
