class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :invoice_items, through: :items

  class << self
    def find_by_name(query)
      where("name ilike ?", "%#{query}%").order(:name).first
    end

    def order_by_revenue(quantity)
       joins(invoices: :invoice_items)
      .merge(Invoice.revenue_invoices)
      .select('merchants.*, sum(quantity * invoice_items.unit_price) as revenue')
      .group(:id)
      .order(revenue: :desc)
      .limit(quantity)
    end
  end
end
