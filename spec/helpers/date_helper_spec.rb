require 'rails_helper'
require 'date_helper'

include DateHelper

RSpec.describe DateHelper, :type => :helper do

  context "Define date ranges" do

    before(:each) do
      now = Time.now
      last_day = now.at_end_of_month.strftime("%d")
    end

    it "must cover current month when no param is given" do
      inital = now.strftime("%Y-%m-01 00:00:00.000")
      final = now.strftime("%Y-%m-#{last_day} 23:59:59.999")

      range = DateHelper.date_range
      expect(range.first.strftime("%Y-%m-01 00:00:00.000")).to eq inital
      expect(range.last.strftime("%Y-%m-#{last_day} 23:59:59.999")).to eq final
    end

  end

end