require 'rails_helper'

describe 'find merchants API' do
  before :each do
    create_list(:merchant, 50)
    create(:merchant, name: 'Icelantic')
    create(:merchant, name: 'Land Rover')
  end

  it 'gets all merchants matching name search' do
    get '/api/v1/merchants/find_all?name=LaN'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data]).to be_an Array
    expect(merchants[:data].length).to eq(2)
    expect(merchants[:data][0][:attributes][:name]).to eq('Icelantic')
    expect(merchants[:data][1][:attributes][:name]).to eq('Land Rover')
  end

  it 'returns array if no match' do
    get '/api/v1/merchants/find_all?name=zzzzzzz'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data]).to be_an Array
    expect(merchants[:data]).to be_empty
  end
end
