class Api::V1::MerchantsController < ApplicationController
  def index
    per_page = params.fetch(:per_page, 20)
    if params[:page].to_i > 0
      page = per_page * (params.fetch(:page, 1).to_i - 1)
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
    no_object_error(params[:id])
  end

  def find
    merchant = Merchant.find_by_name(params[:name])
    if !params[:name] || params[:name] == ''
      no_params_error
    elsif !merchant
      render json: {
        data: { message: "no merchant name found including '#{params[:name]}'" }
        }
    else
      render json: MerchantSerializer.new(merchant)
    end
  end

  def most_items
    if params[:quantity].to_i < 1
      no_params_error
    else
      merchants = Merchant.most_items(params[:quantity])
      render json: ItemsSoldSerializer.new(merchants)
    end
  end
end
