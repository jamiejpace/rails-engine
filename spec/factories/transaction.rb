FactoryBot.define do
  factory :transaction, class: Transaction do
    association :invoice
    credit_card_number { Faker::Number.number(digits: 16).to_s }
    credit_card_expiration_date { Faker::Business.credit_card_expiry_date.to_s }
    result { ["success", "failed"].sample }
    id { Faker::Number.unique.within(range: 1..100_000) }
  end
end
