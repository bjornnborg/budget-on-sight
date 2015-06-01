# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category do
    category_type :debit
    description "Lunch"
    frequency :occasionally
    disabled false
    group "Food"

    trait :disabled do
        disabled true
    end

    trait :credit do
        group "Income"
        category_type :credit
        description "Salary"
    end

    factory :credit, traits: [:credit]
    
  end

end