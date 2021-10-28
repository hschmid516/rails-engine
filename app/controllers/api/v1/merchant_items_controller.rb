class Api::V1::MerchantItemsController < Api::V1::Items::BaseController
  def index
    merchant = Merchant.find(params[:merchant_id])
    serialize(merchant.items)
  end
end
