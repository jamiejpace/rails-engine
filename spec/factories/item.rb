FactoryBot.define do
  factory :item, class: Item do
    association :merchant
    name { Faker::Commerce.product_name }
    description { Faker::ChuckNorris.fact }
    unit_price { Faker::Number.decimal(1_digits: 2) }
    id { Faker::Number.unique.within(range: 1..100_000) }
  end
end
