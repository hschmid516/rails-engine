require 'rails_helper'

RSpec.describe Merchant, type: :model do
  it { should have_many(:items) }

  it '#find_by_name' do
    merch1 = create(:merchant, name: 'Icelantic')
    merch2 = create(:merchant, name: 'Land Rover')

    expect(Merchant.find_by_name('LaN')).to eq(merch1)
  end

  it '#order_by_revenue' do
    @merch1 = create(:merchant)
    item1 = create(:item, merchant: @merch1)
    cust1 = create(:customer)
    inv1 = @merch1.invoices.create(customer: cust1)
    inv1.invoice_items.create(item: item1, quantity: 10, unit_price: 100)

    @merch2 = create(:merchant)
    item2 = create(:item, merchant: @merch2)
    cust2 = create(:customer)
    inv2 = @merch2.invoices.create(customer: cust2)
    inv2.invoice_items.create(item: item2, quantity: 10, unit_price: 200)

    @merch3 = create(:merchant)
    item3 = create(:item, merchant: @merch3)
    cust3 = create(:customer)
    inv3 = @merch3.invoices.create(customer: cust3)
    inv3.invoice_items.create(item: item3, quantity: 10, unit_price: 300)

    expect(Merchant.order_by_revenue(2)).to eq([@merch3, @merch2])
  end
end
