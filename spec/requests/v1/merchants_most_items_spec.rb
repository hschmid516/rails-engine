require 'rails_helper'

describe 'merchants most items API' do
  before :each do
    @merch1 = create(:merchant)
    item1 = create(:item, merchant: @merch1)
    cust1 = create(:customer)
    inv1 = @merch1.invoices.create(customer: cust1, status: 'shipped')
    inv1.invoice_items.create(item: item1, quantity: 10, unit_price: 100)
    inv1.invoice_items.create(item: item1, quantity: 10, unit_price: 100)
    inv1.transactions.create(result: 'success')

    @merch2 = create(:merchant)
    item2 = create(:item, merchant: @merch2)
    cust2 = create(:customer)
    inv2 = @merch2.invoices.create(customer: cust2, status: 'shipped')
    inv2.invoice_items.create(item: item2, quantity: 20, unit_price: 200)
    inv2.invoice_items.create(item: item2, quantity: 20, unit_price: 200)
    inv2.transactions.create(result: 'success')

    @merch3 = create(:merchant)
    item3 = create(:item, merchant: @merch3)
    cust3 = create(:customer)
    inv3 = @merch3.invoices.create(customer: cust3, status: 'shipped')
    inv3.invoice_items.create(item: item3, quantity: 30, unit_price: 300)
    inv3.invoice_items.create(item: item3, quantity: 30, unit_price: 300)
    inv3.transactions.create(result: 'success')

    @merch4 = create(:merchant)
    item4 = create(:item, merchant: @merch4)
    cust4 = create(:customer)
    inv4 = @merch4.invoices.create(customer: cust4, status: 'shipped')
    inv4.invoice_items.create(item: item4, quantity: 40, unit_price: 400)
    inv4.invoice_items.create(item: item4, quantity: 40, unit_price: 400)
    inv4.transactions.create(result: 'success')

    @merch5 = create(:merchant)
    item5 = create(:item, merchant: @merch5)
    cust5 = create(:customer)
    inv5 = @merch5.invoices.create(customer: cust5, status: 'shipped')
    inv5.invoice_items.create(item: item5, quantity: 1000, unit_price: 1000)
    inv5.invoice_items.create(item: item5, quantity: 1000, unit_price: 1000)
    inv5.transactions.create(result: 'failed')
  end

  it 'gets merchants ranked by items sold' do
    get '/api/v1/merchants/most_items?quantity=2'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants).to be_a Hash
    expect(merchants[:data]).to be_an Array
    expect(merchants[:data].length).to eq(2)
    expect(merchants[:data][0][:id].to_i).to eq(@merch4.id)
    expect(merchants[:data][0][:attributes][:count]).to eq(80)
    expect(merchants[:data][1][:id].to_i).to eq(@merch3.id)
    expect(merchants[:data][1][:attributes][:count]).to eq(60)
  end

  it 'returns error if no quantity' do
    get '/api/v1/merchants/most_items?quantity='

    expect(response).to have_http_status(400)
  end

  it 'returns error if quantity <= 1' do
    get '/api/v1/merchants/most_items?quantity=-1'

    expect(response).to have_http_status(400)
  end
end
