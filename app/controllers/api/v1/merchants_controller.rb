class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = Merchant.limit(number_per_page).offset((page_number - 1) * number_per_page)
    render json: MerchantSerializer.new(merchants)
  end

  private

  def number_per_page
    params.fetch(:per_page, 20).to_i
  end

  def page_number
    if params[:page] && params[:page].to_i > 0
      params[:page].to_i
    else
      1
    end
  end
end
