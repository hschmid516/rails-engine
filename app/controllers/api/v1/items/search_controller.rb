class Api::V1::Items::SearchController < Api::V1::Items::BaseController
  def index
    items = Item.find_all_items(params)
    if name_search && bad_params
      bad_params_error
    elsif name_search
      serialize(items)
    else
      params[:name] ? search_error : serialize(items)
    end
  end
end
