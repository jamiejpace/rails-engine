require 'rails_helper'

RSpec.describe 'Find one merchant endpoint' do
  it 'can return one merchant based on name search input' do
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

  it 'renders an error if name is left blank' do
    get '/api/v1/merchants/find', params: { name: "" }

    expect(response).to_not be_successful
    expect(response.status).to eq(400)
  end

  it 'returns an object with nil values for attributes if no merchant returned from search' do
    get '/api/v1/merchants/find', params: { name: "yellow" }

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant[:data][:attributes][:name]).to be(nil)
  end
end
