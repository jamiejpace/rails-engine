require 'rails_helper'

RSpec.describe 'Items show endpoint' do
  it 'returns one item based on an id' do
    item = create(:item)

    get "/api/v1/items/#{item.id}"

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)

    expect(item).to have_key(:data)
    expect(item[:data]).to be_a(Hash)

    expect(item[:data][:id]).to be_a(String)
    expect(item[:data][:type]).to be_a(String)
    expect(item[:data][:attributes]).to be_a(Hash)

    expect(item[:data][:attributes]).to have_key(:name)
    expect(item[:data][:attributes][:name]).to be_a(String)

    expect(item[:data][:attributes]).to have_key(:description)
    expect(item[:data][:attributes][:description]).to be_a(String)

    expect(item[:data][:attributes]).to have_key(:unit_price)
    expect(item[:data][:attributes][:unit_price]).to be_a(Float)

    expect(item[:data][:attributes]).to have_key(:merchant_id)
    expect(item[:data][:attributes][:merchant_id]).to be_a(Integer)
  end

  it 'returns 404 status if item id not valid' do
    item = create(:item, id: 1)

    get "/api/v1/items/2"

    expect(response.status).to eq(404)
  end
end
