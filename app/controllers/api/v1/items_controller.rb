class Api::V1::ItemsController < ApplicationController
  before_action only: [:show, :update, :destroy] do
    @item = find_object(Item)
  end

  def index
    items = paginate(Item)
    render json: ItemSerializer.new(items)
  end

  def show
    render json: ItemSerializer.new(@item)
  end

  def create
    item = Item.create!(item_params)
    render json: ItemSerializer.new(item), status: :created
  end

  def update
    @item.update!(item_params)
    render json: ItemSerializer.new(@item)
  end

  def destroy
    @item.destroy
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
