require 'rails_helper'

describe 'merchants API' do
  it 'gets  merchants' do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchants).to be_an(Array)
    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(String)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
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
end
