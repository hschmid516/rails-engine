class Api::V1::Merchants::BaseController < ApplicationController
  private

  def serialize(merchants)
    render json: MerchantSerializer.new(merchants)
  end

  def find_merchant
    Merchant.find(params[:id])
  end

  def find_merchants
    Merchant.find_all_merchants(params[:name])
  end

  def process_merchants(merchants)
    if bad_params
      bad_params_error
    elsif !merchants
      render json: { data: { message: "no results found" } }
    else
      serialize(merchants)
    end
  end
end
