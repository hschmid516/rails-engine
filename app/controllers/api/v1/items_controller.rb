class Api::V1::ItemsController < Api::V1::Items::BaseController
  before_action only: [:show, :update, :destroy] do
    @item = find_item
  end

  def index
    items = paginate(Item)
    serialize(items)
  end

  def show
    serialize(@item)
  end

  def create
    item = Item.create!(item_params)
    render json: ItemSerializer.new(item), status: :created
  end

  def update
    @item.update!(item_params)
    serialize(@item)
  end

  def destroy
    @item.destroy
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
