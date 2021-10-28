require 'rails_helper'

describe 'find items API' do
  before :each do
    merchant = create(:merchant)
    create(:item, name: 'ski bindings', merchant: merchant, unit_price: 10)
    create(:item, name: 'Snowboard Bindings', merchant: merchant, unit_price: 10)
    create_list(:item, 8, merchant: merchant, unit_price: 10)
    create_list(:item, 20, merchant: merchant, unit_price: 20)
    create_list(:item, 30, merchant: merchant, unit_price: 30)
  end

  it 'gets all items matching name search' do
    get '/api/v1/items/find_all?name=bInD'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data]).to be_an Array
    expect(items[:data].length).to eq(2)
    expect(items[:data][0][:attributes][:name]).to eq('ski bindings')
    expect(items[:data][1][:attributes][:name]).to eq('Snowboard Bindings')
  end

  it 'returns array if no match' do
    get '/api/v1/items/find_all?name=zzzzzzz'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data]).to be_an Array
    expect(items[:data]).to be_empty
  end

  it 'gets all items matching min price search' do
    get '/api/v1/items/find_all?min_price=19.50'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data]).to be_an Array
    expect(items[:data].count).to eq(50)
  end

  it 'gets all items matching max price search' do
    get '/api/v1/items/find_all?max_price=20.50'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data]).to be_an Array
    expect(items[:data].count).to eq(30)
  end

  it 'gets all items between min and max' do
    get '/api/v1/items/find_all?min_price=19.50&max_price=20.50'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data]).to be_an Array
    expect(items[:data].count).to eq(20)
  end

  it 'gets error if params include name and min/max' do
    get '/api/v1/items/find_all?max_price=19.50&name=bind'

    expect(response).to have_http_status(400)

    error = JSON.parse(response.body, symbolize_names: true)

    expect(error[:error]).to eq("params cannot include name and max/min price")
    expect(error[:message]).to eq("items could not be found")
  end

  it 'gets error if no params or query is empty' do
    get '/api/v1/items/find_all'

    expect(response).to have_http_status(400)

    error = JSON.parse(response.body, symbolize_names: true)

    expect(error[:message]).to eq("object could not be found")

    get '/api/v1/items/find_all?name='

    expect(response).to have_http_status(400)
  end
end
