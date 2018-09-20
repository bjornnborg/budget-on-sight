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
      frequency {:monthly}
    end

    trait :weekly do
      frequency :weekly
    end

    trait :daily do
      frequency :daily
    end

    trait :oftenly do
      frequency :oftenly
    end

    factory :credit, traits: [:credit]
    factory :monthly, traits: [:monthly]
    factory :weekly, traits: [:weekly]
    factory :daily, traits: [:daily]
    factory :oftenly, traits: [:oftenly]
    
  end

end
