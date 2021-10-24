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

  def create
    item = Item.new(item_params)
    if item.save
      render json: ItemSerializer.new(item), status: 201
    else
      render json: {error: "not-found"}, status: 404
    end
  end

  def update
    item = Item.find(params[:id])
    if item.update(item_params)
      render json: ItemSerializer.new(item)
    else
      render json: {error: "not-found"}, status: 404
    end
  end

  def destroy
    Item.delete(params[:id])
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
