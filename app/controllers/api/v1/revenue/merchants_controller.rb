class Api::V1::Revenue::MerchantsController < Api::V1::Merchants::BaseController
  def index
    if params[:quantity].to_i < 1
      bad_params_error
    else
      merchants = Merchant.order_by_revenue(params[:quantity])
      render json: MerchantNameRevenueSerializer.new(merchants)
    end
  end

  def show
    revenue = find_merchant.total_revenue[0]
    render json: MerchantRevenueSerializer.new(revenue)
  end

  def date_range
    if validate_range
      revenue = Merchant.revenue_for_range(params[:start], params[:end])[0]
      render json: RevenueRangeSerializer.new(revenue)
    else
      bad_params_error
    end
  end

  private

  def validate_range
    (params[:start] && params[:end]) && !(params[:start].empty? || params[:end].empty?)
  end
end
