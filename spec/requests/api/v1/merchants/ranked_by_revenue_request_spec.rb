require 'rails_helper'

RSpec.describe 'Merchants ranked by revenue endpoint' do
  it 'returns a quantity of merchants sorted by desc revenue' do
    merchant2 = create(:merchant, name: "Second")
    merchant1 = create(:merchant, name: "The Best")
    merchant3 = create(:merchant, name: "Worst")

    customer1 = create(:customer)

    item1 = create(:item, merchant_id: merchant1.id)
    item2 = create(:item, merchant_id: merchant1.id)
    item3 = create(:item, merchant_id: merchant2.id)
    item4 = create(:item, merchant_id: merchant2.id)
    item5 = create(:item, merchant_id: merchant3.id)
    item6 = create(:item, merchant_id: merchant3.id)

    invoice1 = create(:invoice, customer_id: customer1.id, merchant_id: merchant1.id)
    invoice2 = create(:invoice, customer_id: customer1.id, merchant_id: merchant2.id)

    invoice_item1 = create(:invoice_item, item_id: item1.id, invoice_id: invoice1.id, quantity: 10, unit_price: 5.00)
    invoice_item2 = create(:invoice_item, item_id: item2.id, invoice_id: invoice1.id, quantity: 10, unit_price: 2.00)
    invoice_item3 = create(:invoice_item, item_id: item3.id, invoice_id: invoice2.id, quantity: 5, unit_price: 3.00)

    transaction1 = create(:transaction, invoice_id: invoice1.id, result: "success")
    transaction2 = create(:transaction, invoice_id: invoice2.id, result: "success")

    get "/api/v1/revenue/merchants", params: { quantity: 2 }

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)
  end

  it 'returns a 400 if quantity is a string' do
    get "/api/v1/revenue/merchants", params: { quantity: "abc" }

    expect(response).to_not be_successful
    expect(response.status).to eq(400)
  end
end
