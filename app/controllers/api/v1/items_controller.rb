class Api::V1::ItemsController < ApplicationController
  include Pagination
  include ErrorHandling

  def index
    if params[:merchant_id]
      if Merchant.exists?(params[:merchant_id])
        items = Item.all_items_for_merchant(params[:merchant_id])
        render json: ItemSerializer.new(items)
      else
        item_404
      end
    else
      items = Item.limit(number_per_page).offset(page_number * number_per_page)
      render json: ItemSerializer.new(items)
    end
  end

  def show
    item = Item.find_by(id: params[:id])
    if item
      render json: ItemSerializer.new(item)
    else
      item_404
    end
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: ItemSerializer.new(item), status: 201
    else
      item_404
    end
  end

  def update
    item = Item.find_by(id: params[:id])
    if item && item.update(item_params)
      render json: ItemSerializer.new(item)
    else
      item_404
    end
  end

  def destroy
    Item.delete(params[:id])
  end

  def find_all
    if params[:name] && !params[:min_price] && !params[:max_price]
      if params[:name].empty?
        bad_request_400
      else
        items = Item.find_items_by_name(params[:name])
        render json: ItemSerializer.new(items)
      end
    elsif !params[:name] && (params[:min_price] || params[:max_price])
      items = Item.find_items_by_price(params[:min_price], params[:max_price])
      render json: ItemSerializer.new(items)
    else
      bad_request_400
    end
  end

  private


  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
