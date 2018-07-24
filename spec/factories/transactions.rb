FactoryBot.define do
  factory :transaction do
    date Time.zone.now
    amount -100
    association :category, strategy: :build
  end

  trait :credit do
    amount 100
    association :category, factory: [:category, :credit], strategy: :build
  end
end
