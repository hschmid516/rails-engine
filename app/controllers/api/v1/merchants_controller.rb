class Api::V1::MerchantsController < ApplicationController
  def index
    per_page = params.fetch(:per_page, 20)
    if params[:page].to_i > 0
      page =  per_page * (params.fetch(:page, 1).to_i - 1)
    else
      page = 0
    end
    merchants = Merchant.limit(per_page).offset(page)
    render json: MerchantSerializer.new(merchants)
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantSerializer.new(merchant)

  rescue ActiveRecord::RecordNotFound
    render json: {
      message: "your query could not be completed",
      errors: ["no merchant found with id: #{params[:id]}"],
      code: 404 }
  end
end
