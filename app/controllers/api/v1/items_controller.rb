class Api::V1::ItemsController < ApplicationController
  def index
    items = Item.limit(number_per_page).offset(page_number * number_per_page)
    render json: ItemSerializer.new(items)
  end
end
