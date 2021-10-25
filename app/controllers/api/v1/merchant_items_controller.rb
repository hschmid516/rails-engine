class Api::V1::MerchantItemsController < ApplicationController
  def index
    merchant = Merchant.find(params[:merchant_id])
    items = merchant.items
    render json: ItemSerializer.new(items)

  rescue ActiveRecord::RecordNotFound
    no_object_error(params[:merchant_id])
  end
end
