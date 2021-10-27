require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'class methods' do
    describe '#find_merchant_by_name' do
      it 'returns the first merchant found in search' do
        merchant1 = create(:merchant, name: "Little Book Store")
        merchant2 = create(:merchant, name: "Big Book Store")
        merchant3 = create(:merchant, name: "Medium Book Store")

        expect(Merchant.find_merchant_by_name("Book")).to eq([merchant2, merchant1, merchant3])
      end
    end
  end
end
