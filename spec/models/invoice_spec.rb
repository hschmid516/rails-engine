require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should belong_to(:customer) }
    it { should have_many(:invoice_items) }
    it { should have_many(:transactions) }
    it { should have_many(:items).through(:invoice_items) }
  end

  it '#successful_invoices' do
    merch1 = create(:merchant)
    create(:item, merchant: merch1)
    cust1 = create(:customer)
    inv1 = merch1.invoices.create(customer: cust1, status: 'shipped')
    inv1.transactions.create(result: 'success')

    merch2 = create(:merchant)
    create(:item, merchant: merch2)
    cust2 = create(:customer)
    inv2 = merch2.invoices.create(customer: cust2, status: 'shipped')
    inv2.transactions.create(result: 'success')

    merch3 = create(:merchant)
    create(:item, merchant: merch3)
    cust3 = create(:customer)
    inv3 = merch3.invoices.create(customer: cust3, status: 'packaged')
    inv3.transactions.create(result: 'success')

    merch4 = create(:merchant)
    create(:item, merchant: merch4)
    cust4 = create(:customer)
    inv4 = merch4.invoices.create(customer: cust4, status: 'shipped')
    inv4.transactions.create(result: 'failed')

    expect(Invoice.successful_invoices).to eq([inv1, inv2])
  end
end
