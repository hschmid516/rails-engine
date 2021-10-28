class Api::V1::ItemsMerchantController < Api::V1::Merchants::BaseController
  def show
    merchant = Item.find(params[:item_id]).merchant
    serialize(merchant)
  end
end
