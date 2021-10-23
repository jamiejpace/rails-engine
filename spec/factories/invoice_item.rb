FactoryBot.define do
  factory :invoice_item, class: InvoiceItem do
    association :item
    association :invoice
    quantity { Faker::Number.within(range: 1..1000) }
    unit_price { Faker::Number.decimal(1_digits: 2) }
    status { [0, 1, 2].sample }
    id { Faker::Number.unique.within(range: 1..1_000_000) }
  end
end
