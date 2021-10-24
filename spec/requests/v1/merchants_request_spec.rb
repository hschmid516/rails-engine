require 'rails_helper'

describe 'merchants API' do
  it 'gets  merchants' do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants).to be_a(Hash)
    expect(merchants[:data]).to be_an(Array)
    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(String)
      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
      expect(merchant[:attributes]).to_not have_key(:created_at)
      expect(merchant[:attributes]).to_not have_key(:updated_at)
    end
  end

  it 'defaults to 20 merchants and page 1' do
    create_list(:merchant, 50)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchants.count).to eq(20)
    expect(merchants.first[:id].to_i).to eq(Merchant.first.id)
  end

  it 'can take per_page and page params to limit and offset' do
    create_list(:merchant, 50)

    get '/api/v1/merchants', params: { per_page: 10, page: 2 }

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchants.count).to eq(10)
    expect(merchants.first[:id].to_i).to eq(Merchant.offset(10).first.id)
  end

  it 'fetches 1 page if page param is < 1 or non-integer' do
    create_list(:merchant, 3)

    get '/api/v1/merchants', params: { page: 0 }

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchants.count).to eq(3)

    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(String)
    end

    get '/api/v1/merchants', params: { page: -5 }

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchants.count).to eq(3)

    get '/api/v1/merchants', params: { page: 'page 8' }

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchants.count).to eq(3)
  end

  it 'can get one merchant' do
    merchant = create(:merchant)

    get "/api/v1/merchants/#{merchant.id}"

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant).to be_a(Hash)
    expect(merchant[:data]).to be_a(Hash)
    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data][:id]).to be_an(String)
    expect(merchant[:data][:attributes]).to have_key(:name)
    expect(merchant[:data][:attributes][:name]).to be_a(String)
    expect(merchant[:data][:attributes]).to_not have_key(:created_at)
    expect(merchant[:data][:attributes]).to_not have_key(:updated_at)
  end

  it 'has 404 error if bad id' do
    create(:merchant)

    get "/api/v1/merchants/2"

    expect(response).to_not be_successful
    expect(response).to have_http_status(404)
  end
end
