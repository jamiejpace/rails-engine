require 'rails_helper'

RSpec.describe 'Items create endpoint' do
  it 'can create an item' do
    merchant = create(:merchant)
    item_params = { name: "Dog Bolo Tie", description: "The cutest bolo tie ever!", unit_price: 10.99, merchant_id: merchant.id }

    post '/api/v1/items', params: { item: item_params }

    expect(response).to be_successful
    expect(response.status).to eq(201)

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

  it 'can not create an item if attributes are missing' do
    merchant = create(:merchant)
    item_params = { name: "Dog Bolo Tie", description: "The cutest bolo tie ever!", unit_price: 10.99 }

    post '/api/v1/items', params: { item: item_params }

    expect(response).to_not be_successful
    expect(response.status).to eq(404)
  end

  it 'ignores attributes that are not allowed' do
    merchant = create(:merchant)
    item_params = { name: "Dog Bolo Tie", description: "The cutest bolo tie ever!", unit_price: 10.99, merchant_id: merchant.id, color: "yellow" }

    post '/api/v1/items', params: { item: item_params }

    item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(response.status).to eq(201)

    expect(item).to have_key(:data)
    expect(item[:data]).to be_a(Hash)

    expect(item[:data][:id]).to be_a(String)
    expect(item[:data][:type]).to be_a(String)
    expect(item[:data][:attributes]).to be_a(Hash)

    expect(item[:data][:attributes]).to_not have_key(:color)
  end
end
