require 'rails_helper'

RSpec.describe 'find items ranked by revenue endpoint' do

  it 'will return a quantity of items ranked by desc revenue' do
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

    invoice_item1 = create(:invoice_item, item_id: item1.id, invoice_id: invoice1.id, quantity: 10, unit_price: 2.00)
    invoice_item2 = create(:invoice_item, item_id: item2.id, invoice_id: invoice1.id, quantity: 10, unit_price: 5.00)
    invoice_item3 = create(:invoice_item, item_id: item3.id, invoice_id: invoice2.id, quantity: 5, unit_price: 3.00)

    transaction1 = create(:transaction, invoice_id: invoice1.id, result: "success")
    transaction2 = create(:transaction, invoice_id: invoice2.id, result: "success")

    get "/api/v1/revenue/items", params: { quantity: 1 }

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items).to be_a(Hash)
    expect(items[:data].count).to eq(1)
  end

  it 'returns up to 10 items by default if no quantity given' do
    merchant1 = create(:merchant)

    customer1 = create(:customer)

    item1 = create(:item, merchant_id: merchant1.id)
    item2 = create(:item, merchant_id: merchant1.id)
    item3 = create(:item, merchant_id: merchant1.id)
    item4 = create(:item, merchant_id: merchant1.id)
    item5 = create(:item, merchant_id: merchant1.id)
    item6 = create(:item, merchant_id: merchant1.id)
    item7 = create(:item, merchant_id: merchant1.id)
    item8 = create(:item, merchant_id: merchant1.id)
    item9 = create(:item, merchant_id: merchant1.id)
    item10 = create(:item, merchant_id: merchant1.id)
    item11 = create(:item, merchant_id: merchant1.id)

    invoice1 = create(:invoice, customer_id: customer1.id, merchant_id: merchant1.id)
    invoice2 = create(:invoice, customer_id: customer1.id, merchant_id: merchant1.id)

    invoice_item1 = create(:invoice_item, item_id: item1.id, invoice_id: invoice1.id, quantity: 10, unit_price: 2.00)
    invoice_item2 = create(:invoice_item, item_id: item2.id, invoice_id: invoice1.id, quantity: 10, unit_price: 5.00)
    invoice_item3 = create(:invoice_item, item_id: item3.id, invoice_id: invoice2.id, quantity: 5, unit_price: 3.00)
    invoice_item4 = create(:invoice_item, item_id: item4.id, invoice_id: invoice2.id, quantity: 5, unit_price: 2.00)
    invoice_item5 = create(:invoice_item, item_id: item5.id, invoice_id: invoice2.id, quantity: 5, unit_price: 1.00)
    invoice_item6 = create(:invoice_item, item_id: item6.id, invoice_id: invoice2.id, quantity: 3, unit_price: 1.00)
    invoice_item7 = create(:invoice_item, item_id: item7.id, invoice_id: invoice2.id, quantity: 3, unit_price: 1.00)
    invoice_item8 = create(:invoice_item, item_id: item8.id, invoice_id: invoice2.id, quantity: 3, unit_price: 1.00)
    invoice_item9 = create(:invoice_item, item_id: item9.id, invoice_id: invoice2.id, quantity: 3, unit_price: 1.00)
    invoice_item10 = create(:invoice_item, item_id: item10.id, invoice_id: invoice2.id, quantity: 3, unit_price: 1.00)
    invoice_item11 = create(:invoice_item, item_id: item11.id, invoice_id: invoice2.id, quantity: 2, unit_price: 1.00)

    transaction1 = create(:transaction, invoice_id: invoice1.id, result: "success")
    transaction2 = create(:transaction, invoice_id: invoice2.id, result: "success")

    get "/api/v1/revenue/items"

    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(items).to be_a(Hash)

    expect(items[:data].count).to eq(10)
  end

  it 'returns all items if quantity is too big' do
    merchant1 = create(:merchant)

    customer1 = create(:customer)

    item1 = create(:item, merchant_id: merchant1.id)
    item2 = create(:item, merchant_id: merchant1.id)
    item3 = create(:item, merchant_id: merchant1.id)
    item4 = create(:item, merchant_id: merchant1.id)
    item5 = create(:item, merchant_id: merchant1.id)
    item6 = create(:item, merchant_id: merchant1.id)
    item7 = create(:item, merchant_id: merchant1.id)
    item8 = create(:item, merchant_id: merchant1.id)
    item9 = create(:item, merchant_id: merchant1.id)
    item10 = create(:item, merchant_id: merchant1.id)
    item11 = create(:item, merchant_id: merchant1.id)

    invoice1 = create(:invoice, customer_id: customer1.id, merchant_id: merchant1.id)
    invoice2 = create(:invoice, customer_id: customer1.id, merchant_id: merchant1.id)

    invoice_item1 = create(:invoice_item, item_id: item1.id, invoice_id: invoice1.id, quantity: 10, unit_price: 2.00)
    invoice_item2 = create(:invoice_item, item_id: item2.id, invoice_id: invoice1.id, quantity: 10, unit_price: 5.00)
    invoice_item3 = create(:invoice_item, item_id: item3.id, invoice_id: invoice2.id, quantity: 5, unit_price: 3.00)
    invoice_item4 = create(:invoice_item, item_id: item4.id, invoice_id: invoice2.id, quantity: 5, unit_price: 2.00)
    invoice_item5 = create(:invoice_item, item_id: item5.id, invoice_id: invoice2.id, quantity: 5, unit_price: 1.00)
    invoice_item6 = create(:invoice_item, item_id: item6.id, invoice_id: invoice2.id, quantity: 3, unit_price: 1.00)
    invoice_item7 = create(:invoice_item, item_id: item7.id, invoice_id: invoice2.id, quantity: 3, unit_price: 1.00)
    invoice_item8 = create(:invoice_item, item_id: item8.id, invoice_id: invoice2.id, quantity: 3, unit_price: 1.00)
    invoice_item9 = create(:invoice_item, item_id: item9.id, invoice_id: invoice2.id, quantity: 3, unit_price: 1.00)
    invoice_item10 = create(:invoice_item, item_id: item10.id, invoice_id: invoice2.id, quantity: 3, unit_price: 1.00)
    invoice_item11 = create(:invoice_item, item_id: item11.id, invoice_id: invoice2.id, quantity: 2, unit_price: 1.00)

    transaction1 = create(:transaction, invoice_id: invoice1.id, result: "success")
    transaction2 = create(:transaction, invoice_id: invoice2.id, result: "success")

    get "/api/v1/revenue/items", params: { quantity: 6 }

    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(items).to be_a(Hash)

    expect(items[:data].count).to eq(6)
  end

  it 'renders a 400 error if a string is given as quantity' do
    get "/api/v1/revenue/items", params: { quantity: "abc"}

    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to_not be_successful
    expect(response.status).to eq(400)
  end

  it 'renders a 400 if quantity is left blank' do
    get "/api/v1/revenue/items", params: { quantity: ""}

    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to_not be_successful
    expect(response.status).to eq(400)
  end

  it 'renders a 400 if quantity is a negative number' do
    get "/api/v1/revenue/items", params: { quantity: -2 }

    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to_not be_successful
    expect(response.status).to eq(400)
  end
end
