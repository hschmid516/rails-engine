class Api::V1::Items::BaseController < ApplicationController
  private

  def serialize(items, status = :ok)
    render json: ItemSerializer.new(items), status: status
  end

  def find_item
    Item.find(params[:id])
  end

  def name_search
    !params[:min_price] && !params[:max_price]
  end

  def find_items
    Item.find_all_items(params)
  end

  def process_items(items)
    if name_search && bad_params
      bad_params_error
    elsif !items
      render json: { data: { message: "no results found" } }
    elsif name_search
      serialize(items)
    else
      params[:name] ? search_error : serialize(items)
    end
  end
end
