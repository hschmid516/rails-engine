require 'rails_helper'

describe 'item merchant API' do
  before :each do
    @merchant = create(:merchant)
    create_list(:item, 3, merchant: @merchant)
  end

  it 'gets an items merchant' do
    get "/api/v1/items/#{Item.first.id}/merchant"

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant).to be_a(Hash)
    expect(merchant[:data]).to be_an(Hash)
    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data][:id]).to be_an(String)
    expect(merchant[:data][:id].to_i).to eq(@merchant.id)
    expect(merchant[:data]).to have_key(:attributes)
    expect(merchant[:data][:attributes]).to have_key(:name)
    expect(merchant[:data][:attributes][:name]).to be_a(String)
  end

  it 'returns 404 if merchant is not found' do
    get "/api/v1/items/10000/merchant"

    expect(response).to_not be_successful
    expect(response).to have_http_status(404)
  end
end
