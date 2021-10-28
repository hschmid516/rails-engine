class Api::V1::Items::BaseController < ApplicationController
  private

  def serialize(items, status = :ok)
    render json: ItemSerializer.new(items), status: status
  end

  def find_item
    Item.find(params[:id])
  end

  def name_search
    !params[:min_price] && !params[:max_price]
  end
end
