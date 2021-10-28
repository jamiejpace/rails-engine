class Api::V1::MerchantsController < ApplicationController
  include Pagination
  include ErrorHandling

  def index
    merchants = Merchant.limit(number_per_page).offset(page_number * number_per_page)
    render json: MerchantSerializer.new(merchants)
  end

  def show
    merchant = Merchant.find_by(id: params[:id])
    if merchant
      render json: MerchantSerializer.new(merchant)
    else
      merchant_404
    end
  end

  def find
    if params[:name] && !params[:name].empty?
      merchant = Merchant.find_merchant_by_name(params[:name])
      if merchant.size > 0
        render json: MerchantSerializer.new(merchant.first)
      else
        render json: MerchantSerializer.new(Merchant.new), status: 200
      end
    else
      bad_request_400
    end
  end

  def merchant_most_items_sold
    if params[:quantity]
      merchants = Merchant.most_items_sold(params[:quantity])
      render json: MostItemsSerializer.new(merchants)
    else
      bad_request_400
    end
  end
end
