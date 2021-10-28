class Api::V1::Items::SearchController < Api::V1::Items::BaseController
  def index
    items = find_items
    process_items(items)
  end

  def show
    item = find_items.first
    process_items(item)
  end
end
