class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :invoice_items, through: :items

  scope :revenue, -> { joins(invoices: :invoice_items)
                      .merge(Invoice.successful_invoices)
                      .select('merchants.*, sum(quantity * invoice_items.unit_price) as revenue') }

  class << self
    def find_by_name(query)
      where("name ilike ?", "%#{query}%").order(:name).first
    end

    def order_by_revenue(quantity)
       revenue.group(:id)
              .order(revenue: :desc)
              .limit(quantity)
    end

    def most_items(quantity)
       joins(invoices: { invoice_items: :item })
      .merge(Invoice.successful_invoices)
      .select('merchants.*, sum(quantity) as item_count')
      .group(:id)
      .order(item_count: :desc)
      .limit(quantity)
    end

    def revenue_for_range(start_date, end_date)
       joins(invoices: :invoice_items)
      .merge(Invoice.successful_invoices)
      .select('sum(quantity * invoice_items.unit_price) as revenue')
      .where(invoices: { created_at: start_date...end_date.to_date.end_of_day })
    end
  end
end
