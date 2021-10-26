FactoryBot.define do
  factory :invoice, class: Invoice do
    association :customer
    association :merchant
    status { ['cancelled', 'completed', 'in progress'].sample }
  end
end
