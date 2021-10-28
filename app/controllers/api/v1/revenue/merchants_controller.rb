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

  def show
    merchant = Merchant.find(params[:id])
    revenue = merchant.total_revenue[0]
    render json: MerchantRevenueSerializer.new(revenue)

  rescue ActiveRecord::RecordNotFound
    no_object_error(params[:id])
  end

  def date_range
    if (params[:start] && params[:end]) && !(params[:start].empty? || params[:end].empty?)
      revenue = Merchant.revenue_for_range(params[:start], params[:end])[0]
      render json: RevenueRangeSerializer.new(revenue)
    else
      render json: {
        message: "revenue could not be found",
        error: nil,
        }, status: 400
    end
  end
end
