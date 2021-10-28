require 'rails_helper'

describe 'find merchants API' do
  before :each do
    create_list(:merchant, 50)
    create(:merchant, name: 'Icelantic')
    create(:merchant, name: 'Land Rover')
  end

  it 'get first ordered merchant containing name param' do
    get '/api/v1/merchants/find?name=LaN'

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant[:data]).to be_a Hash
    expect(merchant[:data].length).to eq(3)
    expect(merchant[:data][:attributes].length).to eq(1)
    expect(merchant[:data][:attributes][:name]).to eq('Icelantic')
  end

  it 'params cant be missing or empty' do
    get '/api/v1/merchants/find?name='

    expect(response).to have_http_status(400)

    get '/api/v1/merchants/find'

    expect(response).to have_http_status(400)
  end

  it 'returns a successful response and error message for no results' do
    get '/api/v1/merchants/find?name=wrongname'

    expect(response).to be_successful

    json = JSON.parse(response.body, symbolize_names: true)

    message =
      {
        data: {
          message: "no results found"
        }
      }

    expect(json).to eq(message)
  end
end
