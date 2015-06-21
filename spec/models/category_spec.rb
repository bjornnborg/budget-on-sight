require 'rails_helper'

RSpec.describe Category, :type => :model do
  context "Validations" do
    it "must prevent credit categories to be investiment" do
      category = build(:category, :credit, :investment)
      expect(category.valid?).to be false
    end

    it "must allow debit categories to be investiment" do
      category = build(:category, :investment)
      expect(category.valid?).to be true
    end

    it "must allow credit categories" do
      category = build(:category, :credit)
      expect(category.valid?).to be true
    end
  end
end
