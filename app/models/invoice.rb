class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items

  def self.revenue_invoices
     joins(:transactions)
    .where(invoices: {status: 'shipped'}, transactions: {result: 'success'})
  end
end
