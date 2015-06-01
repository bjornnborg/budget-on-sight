require 'rails_helper'

RSpec.describe Category, :type => :model do
  context "all good" do
    it "must work" do
        category = build(:category)
        puts ">>>>>>>>>>>>#{category.category_type}"
        puts ">>>>>>>>>>>>#{category.disabled}"
        puts ">>>>>>>>>>>>#{category.value}"
        category = build(:category, :credit)
        puts ">>>>>>>>>>>>#{category.category_type}"
        puts ">>>>>>>>>>>>#{category.disabled}"
        puts ">>>>>>>>>>>>#{category.value}"
    end
  end
end
