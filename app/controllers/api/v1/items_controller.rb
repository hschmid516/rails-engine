class Api::V1::ItemsController < ApplicationController
  def index
    per_page = params.fetch(:per_page, 20)
    if params[:page].to_i > 0
      page =  per_page * (params.fetch(:page, 1).to_i - 1)
    else
      page = 0
    end
    items = Item.limit(per_page).offset(page)
    render json: ItemSerializer.new(items)
  end
end
