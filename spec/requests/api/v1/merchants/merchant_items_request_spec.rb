require 'rails_helper'

RSpec.describe 'Merchant items endpoint' do
  it 'returns all items associated with a given merchant' do
    merchant = create(:merchant)
    merchant2 = create(:merchant)
    item1 = create(:item, merchant_id: merchant.id)
    item2 = create(:item, merchant_id: merchant.id)
    item3 = create(:item, merchant_id: merchant2.id)

    get "/api/v1/merchants/#{merchant.id}/items"

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(2)
  end

  it 'returns an error if the merchant does not exist' do
    get '/api/v1/merchants/1/items'

    expect(response.status).to eq(404)
  end
end
