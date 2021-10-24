class Api::V1::ItemsController < ApplicationController
  def index
    items = if params[:merchant_id]
              Item.all_items_for_merchant(params[:merchant_id])
            else
              Item.limit(number_per_page).offset(page_number * number_per_page)
            end

    render json: ItemSerializer.new(items)
  end

  def show
    item = Item.find_by(id: params[:id])
    if item
      render json: ItemSerializer.new(item)
    else
      render json: {error: "not-found"}, status: 404
    end
  end
end
