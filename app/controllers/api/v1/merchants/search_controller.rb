class Api::V1::Merchants::SearchController < ApplicationController
  def index
    merchant = Merchant.find_by_name(params[:name])
    if bad_params
      bad_params_error
    elsif !merchant
      render json: { data: { message: "no results found" } }
    else
      render json: MerchantSerializer.new(merchant)
    end
  end
end
