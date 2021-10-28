class Api::V1::Merchants::SearchController < Api::V1::Merchants::BaseController
  def index
    merchant = find_merchants
    process_merchants(merchant)
  end

  def show
    merchant = find_merchants.first
    process_merchants(merchant)
  end
end
