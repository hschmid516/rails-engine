class Api::V1::Merchants::SearchController < Api::V1::Merchants::BaseController
  def index
    merchant = Merchant.find_by_name(params[:name])
    if bad_params
      bad_params_error
    elsif !merchant
      render json: { data: { message: "no results found" } }
    else
      serialize(merchant)
    end
  end
end
