class Api::V1::Items::MerchantController < ApplicationController
  def show
    item = Item.find_by(id: params[:item_id])
    if item
      merchant = Merchant.find_by(id: item.merchant_id)
      render json: MerchantSerializer.new(merchant)
    else
      render json: {error: "not-found"}, status: 404
    end
  end
end
