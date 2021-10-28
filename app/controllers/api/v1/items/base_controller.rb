class Api::V1::Items::BaseController < ApplicationController
  private

  def serialize(items)
    render json: ItemSerializer.new(items)
  end

  def find_item
    Item.find(params[:id])
  end
end
