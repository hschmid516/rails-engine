require 'rails_helper'

describe 'items API' do
  before :each do
    merchant = create(:merchant)
    create_list(:item, 50, merchant: merchant)
    get '/api/v1/items'
  end

  it 'gets  items' do
    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items).to be_a(Hash)
    expect(items[:data]).to be_an(Array)
    items[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_an(String)
      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)
      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)
      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_an(Integer)
      expect(item[:attributes]).to_not have_key(:created_at)
      expect(item[:attributes]).to_not have_key(:updated_at)
    end
  end

  it 'defaults to 20 items and page 1' do
    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(items.count).to eq(20)
    expect(items.first[:id].to_i).to eq(Item.first.id)
  end

  it 'can take per_page and page params to limit and offset' do
    get '/api/v1/items', params: { per_page: 10, page: 2 }

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(items.count).to eq(10)
    expect(items.first[:id].to_i).to eq(Item.offset(10).first.id)
  end

  it 'fetches 1 page if page param is < 1 or non-integer' do
    get '/api/v1/items', params: { page: 0 }

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(items.count).to eq(20)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_an(String)
    end

    get '/api/v1/items', params: { page: -5 }

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(items.count).to eq(20)

    get '/api/v1/items', params: { page: 'page 8' }

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(items.count).to eq(20)
  end
end

describe '1 or 0 items' do
  it 'returns array if only 1 item' do
    merchant = create(:merchant)
    create(:item, merchant: merchant)
    get '/api/v1/items'

    items = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(items).to be_an(Array)
  end

  it 'returns array if 0 items' do
    get '/api/v1/items'

    items = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(items).to be_an(Array)
  end
end
