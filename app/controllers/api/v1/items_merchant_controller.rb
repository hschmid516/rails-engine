class Api::V1::ItemsMerchantController < ApplicationController
  def show
    merchant = Item.find(params[:item_id]).merchant
    render json: MerchantSerializer.new(merchant)

  rescue ActiveRecord::RecordNotFound
    no_object_error(params[:item_id])
  end
end
