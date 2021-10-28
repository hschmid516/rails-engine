class Api::V1::Items::BaseController < ApplicationController
  private

  def serialize(items, status = :ok)
    render json: ItemSerializer.new(items), status: status
  end

  def find_item
    Item.find(params[:id])
  end
end
