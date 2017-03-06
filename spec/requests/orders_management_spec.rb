require 'spec_helper'

describe 'Orders management', type: :request do
  describe 'create' do
    it 'should create Order' do
      # Create Order
      post ORDERS_PATH, params: { order: { restaurant: 'Restaurant under Create Order' } }, headers: access_token_header

      # List orders to check if Order was successfully created
      get ORDERS_PATH, headers: access_token_header

      newest_order = json_response.fetch('results').first
      expect(newest_order).to eql({ "user" => { "email" => "foo@bar.com" }, "restaurant" => "Restaurant under Create Order" })
    end
  end

  describe 'index' do
    before do
      create_order(restaurant: 'Restaurant under Order List #1')
      create_order(restaurant: 'Restaurant under Order List #2')

      # Create order as another user
      create_user('user@order-list.com')
      access_token = get_user_access_token('user@order-list.com')
      create_order(restaurant: 'Restaurant under Order List #3', access_token: access_token)
    end

    it 'should list Orders sorted by created at' do
      get ORDERS_PATH, headers: access_token_header
      three_newest_orders = json_response.fetch('results')[0..2]
      expected = [
        { "user" => { "email" => 'user@order-list.com' }, "restaurant" => "Restaurant under Order List #3" },
        { "user" => { "email" => "foo@bar.com" }, "restaurant" => "Restaurant under Order List #2" },
        { "user" => { "email" => "foo@bar.com" }, "restaurant" => "Restaurant under Order List #1" },
      ]
      expect(three_newest_orders).to eql(expected)
    end
  end
end
