class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = Merchant.limit(number_per_page).offset(page_number * number_per_page)
    render json: MerchantSerializer.new(merchants)
  end
end
