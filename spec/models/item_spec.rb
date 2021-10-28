require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'class methods' do
    describe '#all_items_for_merchant' do
      it 'returns all items for a given merchant' do
        merchant = create(:merchant)
        merchant2 = create(:merchant)
        item1 = create(:item, merchant_id: merchant.id)
        item2 = create(:item, merchant_id: merchant.id)
        item3 = create(:item, merchant_id: merchant2.id)

        expect(Item.all_items_for_merchant(merchant.id)).to eq([item1, item2])
      end
    end

    describe '#find_items_by_name' do
      it 'finds an item by searched for name fragment' do
        merchant = create(:merchant)
        item1 = create(:item, merchant_id: merchant.id, name: "ring pop")
        item2 = create(:item, merchant_id: merchant.id, name: "diamond ring")
        item3 = create(:item, merchant_id: merchant.id, name: "skittles")

        expect(Item.find_items_by_name("ring")).to eq([item2, item1])
      end
    end

    describe '#find_items_by_price' do
      it 'returns all items that fit price parameters' do
        merchant = create(:merchant)
        item1 = create(:item, merchant_id: merchant.id, unit_price: 1.50)
        item2 = create(:item, merchant_id: merchant.id, unit_price: 1.00)
        item3 = create(:item, merchant_id: merchant.id, unit_price: 5.00)

        expect(Item.find_items_by_price(1.25, 2.00)).to eq([item1])
      end
    end

    describe '#by_top_revenue' do
      it 'orders items by highest revenue and returns a given quantity' do
        merchant1 = create(:merchant)

        customer1 = create(:customer)

        item1 = create(:item, merchant_id: merchant1.id)
        item2 = create(:item, merchant_id: merchant1.id)
        item3 = create(:item, merchant_id: merchant1.id)
        item4 = create(:item, merchant_id: merchant1.id)
        item5 = create(:item, merchant_id: merchant1.id)
        item6 = create(:item, merchant_id: merchant1.id)

        invoice1 = create(:invoice, customer_id: customer1.id, merchant_id: merchant1.id)
        invoice2 = create(:invoice, customer_id: customer1.id, merchant_id: merchant1.id)

        invoice_item1 = create(:invoice_item, item_id: item1.id, invoice_id: invoice1.id, quantity: 10, unit_price: 2.00)
        invoice_item2 = create(:invoice_item, item_id: item2.id, invoice_id: invoice1.id, quantity: 10, unit_price: 5.00)
        invoice_item3 = create(:invoice_item, item_id: item3.id, invoice_id: invoice2.id, quantity: 5, unit_price: 3.00)

        transaction1 = create(:transaction, invoice_id: invoice1.id, result: "success")
        transaction2 = create(:transaction, invoice_id: invoice2.id, result: "success")

        expect(Item.by_top_revenue(2)).to eq([item2, item1])
      end
    end
  end
end
