require 'rails_helper'

describe 'find item API' do
  before :each do
    merchant = create(:merchant)
    create(:item, name: 'Ski bindings', merchant: merchant, unit_price: 10)
    create(:item, name: 'Snowboard Bindings', merchant: merchant, unit_price: 10)
    create_list(:item, 8, merchant: merchant, unit_price: 10)
    create_list(:item, 20, merchant: merchant, unit_price: 20)
    create_list(:item, 30, merchant: merchant, unit_price: 30)
  end

  it 'get first ordered item containing name param' do
    get '/api/v1/items/find?name=bInD'

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)

    expect(item[:data]).to be_a Hash
    expect(item[:data].length).to eq(3)
    expect(item[:data][:attributes].length).to eq(4)
    expect(item[:data][:attributes][:name]).to eq('Ski bindings')
  end

  it 'params cant be missing or empty' do
    get '/api/v1/items/find?name='

    expect(response).to have_http_status(400)

    get '/api/v1/items/find'

    expect(response).to have_http_status(400)
  end

  it 'returns a successful response and error message for no results' do
    get '/api/v1/items/find?name=wrongname'

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
