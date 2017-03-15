require 'spec_helper'

describe 'Orders management', type: :request do
  describe 'POST /orders' do
    let(:current_user_email) { 'order-creator@order-create.com' }
    let(:eater_1_email) { 'eater-1@order-create.com' }
    let(:eater_2_email) { 'eater-2@order-create.com' }
    let(:headers) { access_token_header(email: current_user_email) }
    let(:restaurant) { 'Restaurant under Create Order' }

    before do
      create_user(current_user_email)
      create_user(eater_1_email)
      create_user(eater_2_email)
    end

    it 'should create Order with Users' do
      post ORDERS_PATH,
           params:  { order:
                        {
                          eaters_emails: [eater_1_email, eater_2_email],
                          restaurant:    restaurant
                        }
           },
           headers: headers

      newest_order = orders(user: current_user_email).first
      expected     = {
        'user'       => { 'email' => current_user_email },
        'restaurant' => restaurant,
        'eaters'     => [
          { 'email' => eater_1_email },
          { 'email' => eater_2_email },
          { 'email' => current_user_email },
        ]
      }
      expect(newest_order).to eql(expected)
    end

    context 'Orders with Group' do
      let(:group_id) do
        groups_ids(current_user_email: current_user_email).first
      end

      before do
        create_group(creator: current_user_email, members_emails: [eater_1_email])
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

        newest_order = orders(user: current_user_email).first
        expected     = {
          'user'       => { 'email' => current_user_email },
          'restaurant' => restaurant,
          'eaters'     => [
            { 'email' => eater_1_email },
            { 'email' => current_user_email },
          ]
        }
        expect(newest_order).to eql(expected)
      end
    end
  end

  describe 'GET /orders' do
    context 'Orders with Group' do
      let(:group_1_order_data) { { 'user'       => { 'email' => order_creator_1_email },
                                   'eaters'     => [{ 'email' => member_of_group_1_email }, { 'email' => member_of_group_1_and_2_email }, { 'email' => order_creator_1_email }],
                                   'restaurant' => restaurant_1 } }
      let(:group_2_order_data) { { 'user'       => { 'email' => order_creator_2_email },
                                   'eaters'     => [{ 'email' => member_of_group_1_and_2_email }, { 'email' => member_of_group_2_email }, { 'email' => order_creator_2_email }],
                                   'restaurant' => restaurant_2 } }
      let(:member_of_group_1_email) { 'eater-1@orders-index-with-group.com' }
      let(:member_of_group_1_and_2_email) { 'eater-2@orders-index-with-group.com' }
      let(:member_of_group_2_email) { 'eater-3@orders-index-with-group.com' }
      let(:order_creator_1_email) { 'order-creator-1@orders-index-with-group.com' }
      let(:order_creator_2_email) { 'order-creator-2@orders-index-with-group.com' }
      let(:restaurant_1) { 'Restaurant under Group #1' }
      let(:restaurant_2) { 'Restaurant under Group #2' }

      before do
        create_user(order_creator_1_email)
        create_user(order_creator_2_email)
        create_user(member_of_group_1_email)
        create_user(member_of_group_1_and_2_email)
        create_user(member_of_group_2_email)

        create_group(
          creator:        order_creator_1_email, # As 1st User
          members_emails: [member_of_group_1_email, member_of_group_1_and_2_email]) # create Group
        newest_group_id = groups_ids(current_user_email: order_creator_1_email).first
        create_order(# and Create Order for newly created Group
          group_id:           newest_group_id,
          restaurant:         restaurant_1,
          current_user_email: order_creator_1_email)

        create_group(
          creator:        order_creator_2_email, # As 2nd User
          members_emails: [member_of_group_2_email, member_of_group_1_and_2_email]) # create Group
        newest_group_id = groups_ids(current_user_email: order_creator_2_email).first
        create_order(# and Create Order for newly created Group
          group_id:           newest_group_id,
          restaurant:         restaurant_2,
          current_user_email: order_creator_2_email)
      end

      it "should be visible for User who created Order and for Users who belong to Order's Group" do
        [order_creator_1_email, member_of_group_1_email].each do |email|
          get ORDERS_PATH, headers: access_token_header(email: email)
          orders = json_response.fetch('results')

          expect(orders).to eql([group_1_order_data])
        end

        [order_creator_2_email, member_of_group_2_email].each do |email|
          get ORDERS_PATH, headers: access_token_header(email: email)
          orders = json_response.fetch('results')

          expect(orders).to eql([group_2_order_data])
        end

        get ORDERS_PATH, headers: access_token_header(email: member_of_group_1_and_2_email)
        orders = json_response.fetch('results')

        expect(orders).to eql([group_2_order_data,
                               group_1_order_data])
      end
    end

    context 'Orders with Users' do
      let(:order_1_data) { { 'user'       => { 'email' => order_creator_1_email },
                             'eaters'     => [{ 'email' => order_1_eater_email }, { 'email' => order_1_and_2_eater_email }, { 'email' => order_creator_1_email }],
                             'restaurant' => restaurant_1 } }

      let(:order_2_data) { { 'user'       => { 'email' => order_creator_2_email },
                             'eaters'     => [{ 'email' => order_2_eater_email }, { 'email' => order_1_and_2_eater_email }, { 'email' => order_creator_2_email }],
                             'restaurant' => restaurant_2 } }

      let(:order_1_eater_email) { 'eater-1@orders-index-with-users.com' }
      let(:order_1_and_2_eater_email) { 'eater-3@orders-index-with-users.com' }
      let(:order_2_eater_email) { 'eater-2@orders-index-with-users.com' }
      let(:order_creator_1_email) { 'order-creator-1@orders-index-with-users.com' }
      let(:order_creator_2_email) { 'order-creator-2@orders-index-with-users.com' }
      let(:restaurant_1) { 'Restaurant under Cool Users' }
      let(:restaurant_2) { 'Restaurant under Awesome Users' }

      before do
        create_user(order_1_eater_email)
        create_user(order_1_and_2_eater_email)
        create_user(order_2_eater_email)
        create_user(order_creator_2_email)
        create_user(order_creator_1_email)

        create_order(
          eaters_emails:      [order_1_eater_email, order_1_and_2_eater_email],
          restaurant:         restaurant_1,
          current_user_email: order_creator_1_email)
        create_order(
          eaters_emails:      [order_2_eater_email, order_1_and_2_eater_email],
          restaurant:         restaurant_2,
          current_user_email: order_creator_2_email)
      end

      it 'should be visible for User who created Order and for Users who belong to Order' do
        [order_creator_1_email, order_1_eater_email].each do |email|
          get ORDERS_PATH, headers: access_token_header(email: email)
          orders = json_response.fetch('results')

          expect(orders).to eql([order_1_data])
        end

        [order_creator_2_email, order_2_eater_email].each do |email|
          get ORDERS_PATH, headers: access_token_header(email: email)
          orders = json_response.fetch('results')

          expect(orders).to eql([order_2_data])
        end

        get ORDERS_PATH, headers: access_token_header(email: order_1_and_2_eater_email)
        orders = json_response.fetch('results')

        expect(orders).to eql([order_2_data,
                               order_1_data])
      end
    end
  end
end
