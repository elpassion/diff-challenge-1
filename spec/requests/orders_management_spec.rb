require 'spec_helper'

describe 'Orders management', type: :request do
  describe 'create' do
    before do
      create_user('order-creator@order-create.com')
    end

    it 'should create Order' do
      access_token = get_user_access_token(email: 'order-creator@order-create.com')

      post ORDERS_PATH,
           params: { order: { restaurant: 'Restaurant under Create Order' } },
           headers: build_access_token_header(access_token: access_token)

      newest_order = orders(user: 'order-creator@order-create.com').first
      expect(newest_order).to eql({ "user" => { "email" => 'order-creator@order-create.com' }, "restaurant" => "Restaurant under Create Order" })
    end
  end

  describe 'index' do
    context 'Orders with Group' do
      let(:group_1_order_data) { { 'user' => { 'email' => order_creator_1 }, 'restaurant' => restaurant_1 } }
      let(:group_2_order_data) { { 'user' => { 'email' => order_creator_2 }, 'restaurant' => restaurant_2 } }
      let(:member_of_group_1) { 'eater-1@order-list.com' }
      let(:member_of_group_1_and_2) { 'eater-2@order-list.com' }
      let(:member_of_group_2) { 'eater-3@order-list.com' }
      let(:order_creator_1) { 'order-creator-1@order-list.com' }
      let(:order_creator_2) { 'order-creator-2@order-list.com' }
      let(:restaurant_1) { 'Restaurant under Group #1' }
      let(:restaurant_2) { 'Restaurant under Group #2' }

      before do
        create_user(order_creator_1)
        create_user(order_creator_2)
        create_user(member_of_group_1)
        create_user(member_of_group_1_and_2)
        create_user(member_of_group_2)

        get_user_access_token(email: order_creator_1).tap do |access_token|                                     # As a 1st User
          create_group(emails: [member_of_group_1, member_of_group_1_and_2], access_token: access_token) # create Group
          create_order(                                                                                  # and Create Order for newly created Group
            group_id:     groups_ids(access_token: access_token).first,
            restaurant:   restaurant_1,
            access_token: access_token)
        end

        get_user_access_token(email: order_creator_2).tap do |access_token|                                     # As a 2nd User
          create_group(emails: [member_of_group_1_and_2, member_of_group_2], access_token: access_token) # create Group
          create_order(                                                                                  # and Create Order for newly created Group
            group_id:     groups_ids(access_token: access_token).first,
            restaurant:   restaurant_2,
            access_token: access_token)
        end
      end

      it 'should be listed for User who created Order and for Users who belong to Order Groups' do
        [order_creator_1, member_of_group_1].each do |user|
          access_token = get_user_access_token(email: user)
          get ORDERS_PATH, headers: build_access_token_header(access_token: access_token)
          orders = json_response.fetch('results')

          expect(orders).to eql([group_1_order_data])
        end

        [order_creator_2, member_of_group_2].each do |user|
          access_token = get_user_access_token(email: user)
          get ORDERS_PATH, headers: build_access_token_header(access_token: access_token)
          orders = json_response.fetch('results')

          expect(orders).to eql([group_2_order_data])
        end

        access_token = get_user_access_token(email: member_of_group_1_and_2)
        get ORDERS_PATH, headers: build_access_token_header(access_token: access_token)
        orders = json_response.fetch('results')

        expect(orders).to eql([group_2_order_data,
                               group_1_order_data])
      end
    end
  end
end
