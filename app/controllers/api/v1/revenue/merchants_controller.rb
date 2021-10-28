class Api::V1::Revenue::MerchantsController < ApplicationController
  include ErrorHandling

  def ranked_by_revenue
    if params[:quantity] && params[:quantity].to_i > 0
      merchants = Merchant.top_revenue(params[:quantity])
      render json: RevenueSerializer.merchant_name_revenue(merchants)
    else
      bad_request_400
    end
  end

  def total_revenue
    if Merchant.find_by(id: params[:id])
      merchant = Merchant.find_merchant_revenue(params[:id])
      render json: RevenueSerializer.merchant_revenue(merchant)
    else
      merchant_404
    end
  end
end
