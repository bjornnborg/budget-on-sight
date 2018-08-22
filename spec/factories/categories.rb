FactoryBot.define do
  factory :category do
    category_type :debit
    description "Some description"
    frequency :occasionally
    disabled false
    group "Some debit group"

    trait :disabled do
      disabled true
    end

    trait :credit do
      group "Some credit group"
      category_type :credit
    end

    trait :investment do
      investment true
    end

    trait :monthly do
      frequency :monthly
    end

    factory :credit, traits: [:credit]
    factory :monthly, traits: [:monthly]
    
  end

end
