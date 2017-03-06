require 'spec_helper'

describe 'Orders management', type: :request do
  describe 'create' do
    it 'should create Order' do
      # Create Order
      post ORDERS_PATH, params: { order: { restaurant: 'The Place' } }, headers: access_token_header

      # List orders to check if Order was successfully created
      get ORDERS_PATH, headers: access_token_header

      newest_order = json.fetch('results').first
      expect(newest_order).to eql({ "user" => { "email" => "foo@bar.com" }, "restaurant" => "The Place" })
    end
  end
end
