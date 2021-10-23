require 'rails_helper'

describe 'merchants API' do
  it 'gets all merchants 20 at a time' do
    create_list(:merchant, 25)

    get '/api/v1/merchants'

    expect(response).to be_successful
  end
end
