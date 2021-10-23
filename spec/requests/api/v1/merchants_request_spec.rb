require 'rails_helper'

RSpec.describe 'Merchants API' do
  describe 'Merchant index endpoint' do
    it 'returns a list of 20 merchants at a time as default' do
      create_list(:merchant, 22)

      get '/api/v1/merchants'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants).to be_a(Hash)

      expect(merchants).to have_key(:data)
      expect(merchants[:data]).to be_an(Array)

      merchants[:data].each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_a(String)

        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to be_a(String)

        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
      end
    end

    it 'returns a list of 20 merchants given a page number parameter' do
      create_list(:merchant, 22)

      get '/api/v1/merchants', params: { page: 2 }

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(2)
    end

    it 'can return a different number of merchants per page' do
      create_list(:merchant, 30)

      get '/api/v1/merchants', params: { per_page: 25 }

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(25)
    end

    it 'returns an empty array if there are no merchants' do
      get '/api/v1/merchants'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants).to have_key(:data)
      expect(merchants[:data]).to be_an(Array)
      expect(merchants[:data]).to eq([])
    end
  end

  describe 'Merchant show endpoint' do
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

  describe 'Merchant items endpoint' do
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
  end
end
