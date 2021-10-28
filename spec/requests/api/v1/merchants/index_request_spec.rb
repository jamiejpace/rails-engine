require 'rails_helper'

RSpec.describe 'Merchant index endpoint' do
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
