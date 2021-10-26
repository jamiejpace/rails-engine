class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = Merchant.limit(number_per_page).offset(page_number * number_per_page)
    render json: MerchantSerializer.new(merchants)
  end

  def show
    merchant = Merchant.find_by(id: params[:id])
    if merchant
      render json: MerchantSerializer.new(merchant)
    else
      render json: {error: "not-found"}, status: 404
    end
  end

  def find
    if params[:name]
      merchant = Merchant.find_merchant_by_name(params[:name])
      render json: MerchantSerializer.new(merchant)
    else
      render json: {error: "bad request"}, status: 400
    end
  end

  def most_items
    if params[:quantity]
      merchants = Merchant.most_items_sold(params[:quantity])
      render json: MostItemsSerializer.new(merchants)
    else
      render json: {error: "bad request"}, status: 400
    end
  end
end
