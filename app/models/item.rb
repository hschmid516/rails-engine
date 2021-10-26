class Item < ApplicationRecord
  belongs_to :merchant
  validates :name, :description, :unit_price, :merchant_id, presence: true

  def self.find_all_items(params)
    if params[:name]
      where("name ilike :search or description ilike :search", search: "%#{params[:name]}%")
    else
      min = params[:min_price]
      max = params[:max_price]
      min ||= 0
      max ||= Float::INFINITY
      where("unit_price >= ? and unit_price <= ?", min, max)
    end
  end
end
