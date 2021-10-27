class Api::V1::Revenue::MerchantsController < ApplicationController
  def index
    if params[:quantity].to_i < 1
      render json: {
        message: "merchants could not be found",
        error: "query params must be present and not empty",
        }, status: 400
    else
      merchants = Merchant.order_by_revenue(params[:quantity])
      render json: MerchantNameRevenueSerializer.new(merchants)
    end
  end
end
