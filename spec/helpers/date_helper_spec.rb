require 'rails_helper'
require 'date_helper'

include DateHelper

RSpec.describe DateHelper, :type => :helper do

  context "Define date ranges" do

    before(:each) do
      Timecop.freeze(Time.local(2015, 8, 17, 13, 45, 23))
    end

    after(:each) do
      Timecop.return
    end

    it "must cover current month when no param is given" do
      range = DateHelper.date_range
      expect(range.first.strftime("%Y-%m-%d 00:00:00.000")).to eq "2015-08-01 00:00:00.000"
      expect(range.last.strftime("%Y-%m-%d 23:59:59.999")).to eq "2015-08-31 23:59:59.999"
    end

    it "must cover current month when empty params is given" do
      range = DateHelper.date_range({})
      expect(range.first.strftime("%Y-%m-%d 00:00:00.000")).to eq "2015-08-01 00:00:00.000"
      expect(range.last.strftime("%Y-%m-%d 23:59:59.999")).to eq "2015-08-31 23:59:59.999"
    end

    it "must cover current year when only year is given" do
      range = DateHelper.date_range(year: 2013)
      expect(range.first.strftime("%Y-%m-%d 00:00:00.000")).to eq "2013-01-01 00:00:00.000"
      expect(range.last.strftime("%Y-%m-%d 23:59:59.999")).to eq "2013-12-31 23:59:59.999"
    end

    it "must cover given month and year when given" do
      range = DateHelper.date_range(year: 2013, month: 2)
      expect(range.first.strftime("%Y-%m-%d 00:00:00.000")).to eq "2013-02-01 00:00:00.000"
      expect(range.last.strftime("%Y-%m-%d 23:59:59.999")).to eq "2013-02-28 23:59:59.999"
    end

    it "must cover given day when exactly given" do
      range = DateHelper.date_range(year: 2013, month: 2, day: 13)
      expect(range.first.strftime("%Y-%m-%d 00:00:00.000")).to eq "2013-02-13 00:00:00.000"
      expect(range.last.strftime("%Y-%m-%d 23:59:59.999")).to eq "2013-02-13 23:59:59.999"
    end

    it "must stick with current year and month if only day is given" do
      range = DateHelper.date_range(day: 13)
      expect(range.first.strftime("%Y-%m-%d 00:00:00.000")).to eq "2015-08-13 00:00:00.000"
      expect(range.last.strftime("%Y-%m-%d 23:59:59.999")).to eq "2015-08-13 23:59:59.999"
    end

    it "must stick with current year if month is given" do
      range = DateHelper.date_range(month: 5)
      expect(range.first.strftime("%Y-%m-%d 00:00:00.000")).to eq "2015-05-01 00:00:00.000"
      expect(range.last.strftime("%Y-%m-%d 23:59:59.999")).to eq "2015-05-31 23:59:59.999"
    end

    it "must stick with current year if month and day is given" do
      range = DateHelper.date_range(month: 5, day: 18)
      expect(range.first.strftime("%Y-%m-%d 00:00:00.000")).to eq "2015-05-18 00:00:00.000"
      expect(range.last.strftime("%Y-%m-%d 23:59:59.999")).to eq "2015-05-18 23:59:59.999"
    end    

  end

  context "Define next or previous date ranges" do

    before(:each) do
      Timecop.freeze(Time.local(2018, 8, 17, 13, 45, 23))
    end

    after(:each) do
      Timecop.return
    end

    it "must return previous day on daily range" do
      range = (Time.now.at_beginning_of_day..Time.now.at_end_of_day)
      previous_range = DateHelper.previous_date_range(range)

      expect(previous_range.first.strftime("%Y-%m-%d 00:00:00.000")).to eq "2018-08-16 00:00:00.000"
      expect(previous_range.last.strftime("%Y-%m-%d 23:59:59.999")).to eq "2018-08-16 23:59:59.999"
    end

    it "must return previous month on monthly range" do
      range = (Time.now.at_beginning_of_month..Time.now.at_end_of_month)
      previous_range = DateHelper.previous_date_range(range)

      expect(previous_range.first.strftime("%Y-%m-%d 00:00:00.000")).to eq "2018-07-01 00:00:00.000"
      expect(previous_range.last.strftime("%Y-%m-%d 23:59:59.999")).to eq "2018-07-31 23:59:59.999"
    end

    it "must return previous year on yearly range" do
      range = (Time.now.at_beginning_of_year..Time.now.at_end_of_year)
      previous_range = DateHelper.previous_date_range(range)

      expect(previous_range.first.strftime("%Y-%m-%d 00:00:00.000")).to eq "2017-01-01 00:00:00.000"
      expect(previous_range.last.strftime("%Y-%m-%d 23:59:59.999")).to eq "2017-12-31 23:59:59.999"
    end

  end

end
