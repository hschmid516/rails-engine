class Api::V1::MerchantsController < Api::V1::Merchants::BaseController
  def index
    serialize(paginate(Merchant))
  end

  def show
    serialize(find_merchant)
  end

  def most_items
    if params[:quantity].to_i < 1
      bad_params_error
    else
      merchants = Merchant.most_items(params[:quantity])
      render json: ItemsSoldSerializer.new(merchants)
    end
  end
end
