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
    merchant = Merchant.find_merchant_by_name(params[:name])
    render json: MerchantSerializer.new(merchant)

  end

end
