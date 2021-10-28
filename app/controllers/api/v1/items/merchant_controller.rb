class Api::V1::Items::MerchantController < ApplicationController
  include ErrorHandling

  def show
    item = Item.find_by(id: params[:item_id])
    if item
      merchant = Merchant.find_by(id: item.merchant_id)
      render json: MerchantSerializer.new(merchant)
    else
      merchant_404
    end
  end
end
