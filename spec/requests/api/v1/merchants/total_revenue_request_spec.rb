require 'rails_helper'

RSpec.describe 'Merchant total revenue endpoint' do
  it 'returns the revenue for a single merchant' do
    merchant1 = create(:merchant)

    customer1 = create(:customer)

    item1 = create(:item, merchant_id: merchant1.id)
    item2 = create(:item, merchant_id: merchant1.id)
    item3 = create(:item, merchant_id: merchant1.id)
    item4 = create(:item, merchant_id: merchant1.id)
    item5 = create(:item, merchant_id: merchant1.id)
    item6 = create(:item, merchant_id: merchant1.id)

    invoice1 = create(:invoice, customer_id: customer1.id, merchant_id: merchant1.id)
    invoice2 = create(:invoice, customer_id: customer1.id, merchant_id: merchant1.id)

    invoice_item1 = create(:invoice_item, item_id: item1.id, invoice_id: invoice1.id, quantity: 10, unit_price: 5.00)
    invoice_item2 = create(:invoice_item, item_id: item2.id, invoice_id: invoice1.id, quantity: 10, unit_price: 2.00)
    invoice_item3 = create(:invoice_item, item_id: item3.id, invoice_id: invoice2.id, quantity: 5, unit_price: 3.00)

    transaction1 = create(:transaction, invoice_id: invoice1.id, result: "success")
    transaction2 = create(:transaction, invoice_id: invoice2.id, result: "success")

    get "/api/v1/revenue/merchants/#{merchant1.id}"

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)
  end

  it 'renders a 404 if no merchant found for given id' do
    get "/api/v1/revenue/merchants/1"

    expect(response).to_not be_successful
    expect(response.status).to eq(404)
  end
end
