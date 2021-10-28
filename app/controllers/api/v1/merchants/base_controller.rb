class Api::V1::Merchants::BaseController < ApplicationController
  private

  def serialize(merchants)
    render json: MerchantSerializer.new(merchants)
  end

  def find_merchant
    Merchant.find(params[:id])
  end
end
