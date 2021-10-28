require 'rails_helper'

RSpec.describe 'Item update endpoint' do
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
