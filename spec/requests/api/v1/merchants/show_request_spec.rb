require 'rails_helper'

RSpec.describe 'Merchant show endpoint' do
  it 'returns one merchant based on an id' do
    merchant = create(:merchant)

    get "/api/v1/merchants/#{merchant.id}"

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant).to have_key(:data)
    expect(merchant[:data]).to be_a(Hash)

    expect(merchant[:data][:id]).to be_a(String)
    expect(merchant[:data][:type]).to be_a(String)
    expect(merchant[:data][:attributes]).to be_a(Hash)

    expect(merchant[:data][:attributes]).to have_key(:name)
    expect(merchant[:data][:attributes][:name]).to be_a(String)
  end

  it 'returns 404 status if merchant id not valid' do
    merchant = create(:merchant, id: 1)

    get "/api/v1/merchants/2"

    expect(response.status).to eq(404)
  end
end
