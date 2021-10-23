require 'rails_helper'

RSpec.describe 'Merchants API' do
  it 'sends a list of 20 students at a time' do
    create_list(:merchant, 21)

    get '/api/v1/merchants'

    expect(response).to be_successful
  end
end
