class Api::V1::Revenue::ItemsController < ApplicationController
  include ErrorHandling
  
  def ranked_by_revenue
    if !params[:quantity]
      items = Item.by_top_revenue
      render json: RevenueSerializer.item_revenue(items)
    elsif params[:quantity].to_i > 0
      items = Item.by_top_revenue(params[:quantity])
      render json: RevenueSerializer.item_revenue(items)
    else
      bad_request_400
    end
  end
end
