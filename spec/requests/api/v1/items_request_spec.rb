require 'rails_helper'

RSpec.describe 'Items API' do
  describe 'Items index endpoint' do
    it 'returns a list of 20 itms at a time as default' do
      create_list(:item, 22)

      get '/api/v1/items'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items).to be_a(Hash)

      expect(items).to have_key(:data)
      expect(items[:data]).to be_an(Array)

      items[:data].each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_a(String)

        expect(item).to have_key(:type)
        expect(item[:type]).to be_a(String)

        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)

        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_a(Integer)
      end
    end

    it 'returns a list of 20 items given a page number parameter' do
      create_list(:item, 22)

      get '/api/v1/items', params: { page: 2 }

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(2)
    end

    it 'can return a different number of items per page' do
      create_list(:item, 30)

      get '/api/v1/items', params: { per_page: 25 }

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(25)
    end

    it 'returns an empty array if there are no items' do
      get '/api/v1/items'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items).to have_key(:data)
      expect(items[:data]).to be_an(Array)
      expect(items[:data]).to eq([])
    end
  end

  describe 'Item show endpoint' do
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

  describe 'Item create endpoint' do
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

  describe 'Item update endpoint' do
    it 'can update an item' do
      merchant = create(:merchant)
      id = create(:item, merchant_id: merchant.id).id
      previous_name = Item.last.name

      patch "/api/v1/items/#{id}", params: { item: {name: "Dog Bolo Tie"} }
      item = Item.find_by(id: id)

      expect(response).to be_successful
      expect(item.name).to eq("Dog Bolo Tie")
    end

    it 'can not update an item that does not exist' do
      patch "/api/v1/items/2", params: { item: {name: "Dog beanie"} }

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
    end
  end

  describe 'Item delete endpoint' do
    it 'can destroy an item' do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)

      expect(Item.count).to eq(1)

      delete "/api/v1/items/#{item.id}"

      expect(response).to be_successful
      expect(response.status).to eq(204)
      expect(response.body).to be_empty
      expect(Item.count).to eq(0)
      expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    xit 'destroys invoice if deleted item was only item on invoice' do

    end
  end

  describe 'Item merchant endpoint' do
    it 'returns the merchant associated with an item' do
      merchant = create(:merchant)
      item1 = create(:item, merchant_id: merchant.id)

      get "/api/v1/items/#{item1.id}/merchant"

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

    it 'returns an error if item does not exist' do
      item = create(:item, id: 1)

      get '/api/v1/items/2/merchant'

      expect(response.status).to eq(404)
    end
  end

  describe 'Find all items endpoint' do
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

      expect(response.status).to eq(404)
    end
  end
end
