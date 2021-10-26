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

    it 'returns an error if the merchant does not exist' do
      get '/api/v1/merchants/1/items'

      expect(response.status).to eq(404)
    end
  end

  describe 'find one merchant endpoint' do
    it 'can return one merchant based on search input' do
      merchant1 = create(:merchant, name: "Yellow Hat Co")
      merchant2 = create(:merchant, name: "Red Hat Co")

      get '/api/v1/merchants/find', params: { name: "yellow" }

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant.count).to eq(1)
      expect(merchant[:data]).to be_a(Hash)
      expect(merchant[:data][:id]).to be_a(String)
      expect(merchant[:data][:type]).to be_a(String)
      expect(merchant[:data][:attributes]).to be_a(Hash)

      expect(merchant[:data][:attributes]).to have_key(:name)
      expect(merchant[:data][:attributes][:name]).to be_a(String)
    end

    xit 'returns an error' do
      merchant2 = create(:merchant, name: "Red Hat Co")
      get '/api/v1/merchants/find', params: { name: "yellow" }

      expect(response).to be_successful
    end
  end

  describe 'business intelligence endpoints' do
    describe 'find quantity of merchants by revenue' do
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

        invoice_item1 = create(:invoice_item, item_id: item1.id, invoice_id: invoice1.id, quantity: 10)
        invoice_item2 = create(:invoice_item, item_id: item2.id, invoice_id: invoice1.id, quantity: 10)
        invoice_item3 = create(:invoice_item, item_id: item3.id, invoice_id: invoice2.id, quantity: 5)

        transaction1 = create(:transaction, invoice_id: invoice1.id, result: "success")
        transaction2 = create(:transaction, invoice_id: invoice2.id, result: "success")

        get "/api/v1/merchants/most_items", params: { quantity: 2 }

        expect(response).to be_successful

        merchants = JSON.parse(response.body, symbolize_names: true)
      end
    end
  end
end
