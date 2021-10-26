require 'rails_helper'

RSpec.describe Merchant, type: :model do
  it { should have_many(:items) }

  it '#find_by_name' do
    merch1 = create(:merchant, name: 'Icelantic')
    merch2 = create(:merchant, name: 'Land Rover')

    expect(Merchant.find_by_name('LaN')).to eq(merch1)
  end
end
