class Api::V1::MerchantsController < ApplicationController
  before_action only: [:show] do
    @merchant = find_object(Merchant)
  end

  def index
    merchants = paginate(Merchant)
    serialize(merchants)
  end

  def show
    serialize(@merchant)
  end

  def most_items
    if params[:quantity].to_i < 1
      bad_params_error
    else
      merchants = Merchant.most_items(params[:quantity])
      render json: ItemsSoldSerializer.new(merchants)
    end
  end

  private

  def serialize(merchants)
    render json: MerchantSerializer.new(merchants)
  end
end
