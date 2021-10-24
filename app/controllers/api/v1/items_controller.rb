class Api::V1::ItemsController < ApplicationController
  def index
    merchant = Merchant.find(params[:merchant_id])
    items = merchant.items
    render json: ItemSerializer.new(items)

  rescue ActiveRecord::RecordNotFound
    no_merchant_error
  end
end
