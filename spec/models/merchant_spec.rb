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

    describe '#most_items_sold' do
      it 'returns a given quantity of merchants ordered by number of items sold' do
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

        expect(Merchant.most_items_sold(2)).to eq([merchant1, merchant2])
      end
    end

    describe '#top_revenue' do
      it 'returns a given number of merchants ordered by top revenue' do
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

        invoice_item1 = create(:invoice_item, item_id: item1.id, invoice_id: invoice1.id, quantity: 10, unit_price: 5.00)
        invoice_item2 = create(:invoice_item, item_id: item2.id, invoice_id: invoice1.id, quantity: 10, unit_price: 2.00)
        invoice_item3 = create(:invoice_item, item_id: item3.id, invoice_id: invoice2.id, quantity: 5, unit_price: 3.00)

        transaction1 = create(:transaction, invoice_id: invoice1.id, result: "success")
        transaction2 = create(:transaction, invoice_id: invoice2.id, result: "success")

        expect(Merchant.top_revenue(2)).to eq([merchant1, merchant2])
      end
    end

    describe '#find_merchant_revenue' do
      it 'reuturns a given merchant with revenue method' do
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

        invoice_item1 = create(:invoice_item, item_id: item1.id, invoice_id: invoice1.id, quantity: 10, unit_price: 5.00)
        invoice_item2 = create(:invoice_item, item_id: item2.id, invoice_id: invoice1.id, quantity: 10, unit_price: 2.00)
        invoice_item3 = create(:invoice_item, item_id: item3.id, invoice_id: invoice2.id, quantity: 5, unit_price: 3.00)

        transaction1 = create(:transaction, invoice_id: invoice1.id, result: "success")
        transaction2 = create(:transaction, invoice_id: invoice2.id, result: "success")

        expect(Merchant.find_merchant_revenue(merchant1)).to be_a(Merchant)
        expect(Merchant.find_merchant_revenue(merchant1).revenue).to eq(85.00)
      end
    end
  end
end
