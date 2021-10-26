require 'rails_helper'

describe 'items API' do
  before :each do
    @merchant = create(:merchant)
    create_list(:item, 50, merchant: @merchant)
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

  it 'can get one item' do
    get "/api/v1/items/#{Item.first.id}"

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)

    expect(item).to be_a(Hash)
    expect(item[:data]).to be_a(Hash)
    expect(item[:data]).to have_key(:id)
    expect(item[:data][:id]).to be_an(String)
    expect(item[:data][:attributes]).to have_key(:name)
    expect(item[:data][:attributes][:name]).to be_a(String)
    expect(item[:data][:attributes]).to have_key(:description)
    expect(item[:data][:attributes][:description]).to be_a(String)
    expect(item[:data][:attributes]).to have_key(:unit_price)
    expect(item[:data][:attributes][:unit_price]).to be_a(Float)
    expect(item[:data][:attributes]).to have_key(:merchant_id)
    expect(item[:data][:attributes][:merchant_id]).to be_an(Integer)
    expect(item[:data][:attributes]).to_not have_key(:created_at)
    expect(item[:data][:attributes]).to_not have_key(:updated_at)
  end

  it 'has 404 error if bad id' do
    get "/api/v1/items/10000"

    expect(response).to_not be_successful
    expect(response).to have_http_status(404)
  end

  it 'can create a new item' do
    item_params = ({
                    name: "skis",
                    description: "powder twigs",
                    unit_price: 899.99,
                    merchant_id: @merchant.id
                  })
    headers = {"CONTENT_TYPE": "application/json"}

    post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

    created_item = Item.last
    expect(response).to have_http_status(:created)
    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)

    expect(item[:data]).to have_key(:id)
    expect(item[:data][:id]).to be_an(String)
    expect(item[:data][:attributes]).to have_key(:name)
    expect(item[:data][:attributes][:name]).to be_a(String)
    expect(item[:data][:attributes]).to have_key(:description)
    expect(item[:data][:attributes][:description]).to be_a(String)
    expect(item[:data][:attributes]).to have_key(:unit_price)
    expect(item[:data][:attributes][:unit_price]).to be_a(Float)
    expect(item[:data][:attributes]).to have_key(:merchant_id)
    expect(item[:data][:attributes][:merchant_id]).to be_an(Integer)
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
  end

  it 'it ignores additional attributes' do
    item_params = ({
                    name: "skis",
                    description: "powder twigs",
                    unit_price: 899.99,
                    merchant_id: @merchant.id,
                    dont_include: "this"
                  })
    headers = {"CONTENT_TYPE": "application/json"}

    post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

    item = JSON.parse(response.body, symbolize_names: true)
    expect(item[:data][:attributes]).to_not have_key(:dont_include)
  end

  it 'returns error if attributes are missing' do
    item_params = ({
                    description: "powder twigs",
                    unit_price: 899.99,
                    merchant_id: @merchant.id
                  })
    headers = {"CONTENT_TYPE": "application/json"}

    post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

    error = JSON.parse(response.body, symbolize_names: true)

    expect(error[:message]).to eq("item could not be created")
    expect(error[:errors]).to eq(["Name can't be blank"])
  end

  it 'can update an item' do
    id = Item.last.id
    old_name = Item.last.name
    item_params = { name: "frisbee" }
    headers = {"CONTENT_TYPE": "application/json"}

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate(item: item_params)
    item = Item.find(id)

    expect(response).to be_successful
    expect(item.name).to_not eq(old_name)
    expect(item.name).to eq(item_params[:name])
  end

  it 'returns 404 if item not found' do
    item_params = { name: "frisbee" }
    headers = {"CONTENT_TYPE": "application/json"}

    patch "/api/v1/items/10000", headers: headers, params: JSON.generate(item: item_params)

    expect(response).to have_http_status(404)
  end

  it 'can delete an item' do
    expect(Item.count).to eq(50)

    last_item = Item.last

    delete "/api/v1/items/#{last_item.id}"

    expect(response).to be_successful
    expect(response).to have_http_status(204)
    expect(response.body).to be_empty
    expect(Item.count).to eq(49)
    expect{Item.find(last_item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'returns 404 if item not found' do
    expect(Item.count).to eq(50)

    last_item = Item.last

    delete "/api/v1/items/10000"

    expect(response).to have_http_status(404)
    expect(Item.count).to eq(50)
    expect(Item.last).to eq(last_item)
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
