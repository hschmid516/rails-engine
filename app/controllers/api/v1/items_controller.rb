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

  def show
    item = Item.find(params[:id])
    render json: ItemSerializer.new(item)

  rescue ActiveRecord::RecordNotFound
    no_object_error(params[:id])
  end

  def create
    item = Item.create(item_params)
    if item.save
      render json: ItemSerializer.new(item), status: :created
    else
      render json: {
          message: "item could not be created",
          errors: item.errors.full_messages,
        }, status: 404
    end
  end

  def update
    item = Item.find(params[:id])
    item.update(item_params)
    render json: ItemSerializer.new(item)

  rescue ActiveRecord::RecordNotFound
    no_object_error(params[:id])
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
  rescue ActiveRecord::RecordNotFound
    no_object_error(params[:id])
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
