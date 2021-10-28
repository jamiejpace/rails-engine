require 'rails_helper'

RSpec.describe 'Find all items endpoint' do
  it 'returns all items from a name search query' do
    merchant = create(:merchant)
    item1 = create(:item, merchant_id: merchant.id, name: "ring pop")
    item2 = create(:item, merchant_id: merchant.id, name: "diamond ring")
    item3 = create(:item, merchant_id: merchant.id, name: "skittles")

    get "/api/v1/items/find_all", params: { name: "ring" }

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)
    expect(merchants[:data].count).to eq(2)
  end

  it 'renders a 400 if name param exists and is empty' do
    get "/api/v1/items/find_all", params: { name: "" }

    expect(response).to_not be_successful
    expect(response.status).to eq(400)
  end

  it 'returns all items from a max_price search query' do
    merchant = create(:merchant)
    item1 = create(:item, merchant_id: merchant.id, unit_price: 1.50)
    item2 = create(:item, merchant_id: merchant.id, unit_price: 1.00)
    item3 = create(:item, merchant_id: merchant.id, unit_price: 5.00)

    get "/api/v1/items/find_all", params: { max_price: 2.00 }

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)
    expect(items[:data].count).to eq(2)
  end

  it 'returns all items from a min_price search query' do
    merchant = create(:merchant)
    item1 = create(:item, merchant_id: merchant.id, unit_price: 1.50)
    item2 = create(:item, merchant_id: merchant.id, unit_price: 1.00)
    item3 = create(:item, merchant_id: merchant.id, unit_price: 5.00)

    get "/api/v1/items/find_all", params: { min_price: 2.00 }

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)
    expect(items[:data].count).to eq(1)
  end

  it 'returns all items from a min and max price search query' do
    merchant = create(:merchant)
    item1 = create(:item, merchant_id: merchant.id, unit_price: 1.50)
    item2 = create(:item, merchant_id: merchant.id, unit_price: 1.00)
    item3 = create(:item, merchant_id: merchant.id, unit_price: 5.00)
    item3 = create(:item, merchant_id: merchant.id, unit_price: 1.75)

    get "/api/v1/items/find_all", params: { min_price: 1.25, max_price: 2.00 }

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)
    expect(items[:data].count).to eq(2)
  end

  it 'returns a 404 status if there is a name and a price query' do
    merchant = create(:merchant)
    item1 = create(:item, merchant_id: merchant.id, unit_price: 1.50, name: "yellow")
    item2 = create(:item, merchant_id: merchant.id, unit_price: 1.00)
    item3 = create(:item, merchant_id: merchant.id, unit_price: 5.00)
    item3 = create(:item, merchant_id: merchant.id, unit_price: 1.75)

    get "/api/v1/items/find_all", params: { name: "yellow", max_price: 2.00 }

    expect(response.status).to eq(400)
  end
end
