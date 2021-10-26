require 'rails_helper'

RSpec.describe Item, type: :model do
  it { should belong_to(:merchant) }
  it { should have_many(:invoice_items) }
  it { should have_many(:invoices).through(:invoice_items) }

  it '#find_all_items' do
    merchant = create(:merchant)
    item1 = create(:item, name: 'ski bindings', merchant: merchant, unit_price: 10)
    item2 = create(:item, name: 'Snowboard Bindings', merchant: merchant, unit_price: 20)
    item3 = create(:item, name: 'boots', merchant: merchant, unit_price: 30)
    item4 = create(:item, name: 'helmet', merchant: merchant, unit_price: 30)
    params = { name: 'bInD' }

    expect(Item.find_all_items(params)).to eq([item1, item2])

    params = { min_price: 25}

    expect(Item.find_all_items(params)).to eq([item3, item4])

    params = { max_price: 25}

    expect(Item.find_all_items(params)).to eq([item1, item2])

    params = { min_price: 15, max_price: 25}

    expect(Item.find_all_items(params)).to eq([item2])
  end
end
