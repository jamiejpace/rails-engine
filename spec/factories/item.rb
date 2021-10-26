FactoryBot.define do
  factory :item, class: Item do
    association :merchant
    name { Faker::Commerce.product_name }
    description { Faker::ChuckNorris.fact }
    unit_price { Faker::Number.decimal(l_digits: 2) }
  end
end
