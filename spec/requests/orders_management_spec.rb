require 'spec_helper'

describe 'Orders management', type: :request do
  describe 'POST /orders' do
    let(:order_creator) { 'order-creator@order-create.com' }
    let(:first_invited_user) { 'invited_user-1@order-create.com' }
    let(:second_invited_user) { 'invited_user-2@order-create.com' }
    let(:headers) { access_token_header(email: order_creator) }
    let(:restaurant) { 'Restaurant under Create Order' }

    before do
      create_user(order_creator)
      create_user(first_invited_user)
      create_user(second_invited_user)
    end

    it 'should create Order with Users' do
      post ORDERS_PATH,
           params:  { order:
                        {
                          invited_users_emails: [first_invited_user, second_invited_user],
                          restaurant:           restaurant
                        }
           },
           headers: headers

      newest_order = orders(user: order_creator).first
      expected     = {
        'founder'       => { 'email' => order_creator },
        'restaurant'    => restaurant,
        'invited_users' => [
          { 'email' => first_invited_user },
          { 'email' => second_invited_user },
          { 'email' => order_creator },
        ]
      }
      expect(newest_order).to eql(expected)
    end

    context 'Orders with Group' do
      let(:group_id) do
        groups_ids(current_user: order_creator).first
      end

      before do
        create_group(creator: order_creator, members_emails: [first_invited_user])
      end

      it 'should create Order with Group' do
        post ORDERS_PATH,
             params:  { order:
                          {
                            group_id:   group_id,
                            restaurant: restaurant
                          }
             },
             headers: headers

        newest_order = orders(user: order_creator).first
        expected     = {
          'founder'       => { 'email' => order_creator },
          'restaurant'    => restaurant,
          'invited_users' => [
            { 'email' => first_invited_user },
            { 'email' => order_creator },
          ]
        }
        expect(newest_order).to eql(expected)
      end
    end
  end

  describe 'GET /orders' do
    context 'Orders with Group' do
      let(:first_order_data) { { 'founder'       => { 'email' => creator_of_first_order },
                                 'invited_users' => [{ 'email' => member_of_first_group }, { 'email' => member_of_first_and_second_group }, { 'email' => creator_of_first_order }],
                                 'restaurant'    => restaurant_1 } }
      let(:second_order_data) { { 'founder'       => { 'email' => creator_of_second_order },
                                  'invited_users' => [{ 'email' => member_of_first_and_second_group }, { 'email' => member_of_second_group }, { 'email' => creator_of_second_order }],
                                  'restaurant'    => restaurant_2 } }
      let(:member_of_first_group) { 'invited_user-1@orders-index-with-group.com' }
      let(:member_of_first_and_second_group) { 'invited_user-2@orders-index-with-group.com' }
      let(:member_of_second_group) { 'invited_user-3@orders-index-with-group.com' }
      let(:creator_of_first_order) { 'order-creator-1@orders-index-with-group.com' }
      let(:creator_of_second_order) { 'order-creator-2@orders-index-with-group.com' }
      let(:restaurant_1) { 'Restaurant under Group #1' }
      let(:restaurant_2) { 'Restaurant under Group #2' }

      before do
        create_user(creator_of_first_order)
        create_user(creator_of_second_order)
        create_user(member_of_first_group)
        create_user(member_of_first_and_second_group)
        create_user(member_of_second_group)

        create_group(
          creator:        creator_of_first_order,
          members_emails: [member_of_first_group, member_of_first_and_second_group]
        ).tap do
          newest_group_id = groups_ids(current_user: creator_of_first_order).first

          create_order(
            group_id:     newest_group_id,
            restaurant:   restaurant_1,
            current_user: creator_of_first_order)
        end

        create_group(
          creator:        creator_of_second_order,
          members_emails: [member_of_second_group, member_of_first_and_second_group]
        ).tap do
          newest_group_id = groups_ids(current_user: creator_of_second_order).first

          create_order(
            group_id:     newest_group_id,
            restaurant:   restaurant_2,
            current_user: creator_of_second_order)
        end
      end

      it "should be visible for User who created Order and for Users who belong to Order's Group" do
        [creator_of_first_order, member_of_first_group].each do |email|
          get ORDERS_PATH, headers: access_token_header(email: email)
          orders = json_response.fetch('results')

          expect(orders).to eql([first_order_data])
        end

        [creator_of_second_order, member_of_second_group].each do |email|
          get ORDERS_PATH, headers: access_token_header(email: email)
          orders = json_response.fetch('results')

          expect(orders).to eql([second_order_data])
        end

        get ORDERS_PATH, headers: access_token_header(email: member_of_first_and_second_group)
        orders = json_response.fetch('results')

        expect(orders).to eql([second_order_data,
                               first_order_data])
      end
    end

    context 'Orders with Users' do
      let(:order_1_data) { { 'founder'       => { 'email' => creator_of_first_order },
                             'invited_users' => [{ 'email' => user_invited_to_first_order }, { 'email' => user_invited_to_first_and_second_order }, { 'email' => creator_of_first_order }],
                             'restaurant'    => restaurant_1 } }

      let(:order_2_data) { { 'founder'       => { 'email' => creator_of_second_order },
                             'invited_users' => [{ 'email' => user_invited_to_second_order }, { 'email' => user_invited_to_first_and_second_order }, { 'email' => creator_of_second_order }],
                             'restaurant'    => restaurant_2 } }

      let(:user_invited_to_first_order) { 'invited-user-1@orders-index-with-users.com' }
      let(:user_invited_to_first_and_second_order) { 'invited-user-3@orders-index-with-users.com' }
      let(:user_invited_to_second_order) { 'invited-user-2@orders-index-with-users.com' }
      let(:creator_of_first_order) { 'order-creator-1@orders-index-with-users.com' }
      let(:creator_of_second_order) { 'order-creator-2@orders-index-with-users.com' }
      let(:restaurant_1) { 'Restaurant under Cool Users' }
      let(:restaurant_2) { 'Restaurant under Awesome Users' }

      before do
        create_user(user_invited_to_first_order)
        create_user(user_invited_to_first_and_second_order)
        create_user(user_invited_to_second_order)
        create_user(creator_of_second_order)
        create_user(creator_of_first_order)

        create_order(
          invited_users_emails: [user_invited_to_first_order, user_invited_to_first_and_second_order],
          restaurant:           restaurant_1,
          current_user:         creator_of_first_order)

        create_order(
          invited_users_emails: [user_invited_to_second_order, user_invited_to_first_and_second_order],
          restaurant:           restaurant_2,
          current_user:         creator_of_second_order)
      end

      it 'should be visible for User who created Order and for Users who belong to Order' do
        [creator_of_first_order, user_invited_to_first_order].each do |email|
          get ORDERS_PATH, headers: access_token_header(email: email)
          orders = json_response.fetch('results')

          expect(orders).to eql([order_1_data])
        end

        [creator_of_second_order, user_invited_to_second_order].each do |email|
          get ORDERS_PATH, headers: access_token_header(email: email)
          orders = json_response.fetch('results')

          expect(orders).to eql([order_2_data])
        end

        get ORDERS_PATH, headers: access_token_header(email: user_invited_to_first_and_second_order)
        orders = json_response.fetch('results')

        expect(orders).to eql([order_2_data,
                               order_1_data])
      end
    end
  end
end
