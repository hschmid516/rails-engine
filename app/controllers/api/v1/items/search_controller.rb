class Api::V1::Items::SearchController < ApplicationController
  def index
    items = Item.find_all_items(params)
    if name_search && bad_params
      bad_params_error
    elsif name_search
      render json: ItemSerializer.new(items)
    else
      params[:name] ? search_error : render(json: ItemSerializer.new(items))
    end
  end
end
