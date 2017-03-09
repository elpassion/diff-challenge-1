require 'spec_helper'

describe 'Orders management', type: :request do
  describe 'create' do
    it 'should create Order' do
      # Create Order
      post ORDERS_PATH, params: { order: { restaurant: 'Restaurant under Create Order' } }, headers: default_access_token_header

      # List orders to check if Order was successfully created
      get ORDERS_PATH, headers: default_access_token_header

      newest_order = json_response.fetch('results').first
      expect(newest_order).to eql({ "user" => { "email" => "foo@bar.com" }, "restaurant" => "Restaurant under Create Order" })
    end
  end

  describe 'index' do
    before do
      create_user('order-creator-1@order-list.com')
      create_user('order-creator-2@order-list.com')

      create_user('eater-1@order-list.com')
      create_user('eater-2@order-list.com')
      create_user('eater-3@order-list.com')
      create_user('eater-4@order-list.com')

      # post GROUPS_PATH, params: { group: { emails: [ 'eater-1@order-list.com', 'eater-2@order-list.com' ] } }

      access_token = get_user_access_token('order-creator-1@order-list.com')
      create_order(restaurant: 'Restaurant under Order List #1', access_token: access_token)
      create_order(restaurant: 'Restaurant under Order List #2', access_token: access_token)

      access_token = get_user_access_token('order-creator-2@order-list.com')
      create_order(restaurant: 'Restaurant under Order List #3', access_token: access_token)
    end

    it 'should list Orders sorted by created at' do
      get ORDERS_PATH, headers: default_access_token_header
      three_newest_orders = json_response.fetch('results')[0..2]
      expected = [
        { "user" => { "email" => 'order-creator-2@order-list.com' }, "restaurant" => "Restaurant under Order List #3" },
        { "user" => { "email" => 'order-creator-1@order-list.com' }, "restaurant" => "Restaurant under Order List #2" },
        { "user" => { "email" => 'order-creator-1@order-list.com' }, "restaurant" => "Restaurant under Order List #1" },
      ]
      expect(three_newest_orders).to eql(expected)
    end
  end
end
