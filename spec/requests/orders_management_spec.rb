require 'spec_helper'

describe 'Orders management', type: :request do
  describe 'create' do
    before do
      create_user(current_user_email)
    end

    let(:current_user_email) { 'order-creator@order-create.com' }
    let(:headers) { access_token_header(email: current_user_email) }

    it 'should create Order' do
      post ORDERS_PATH,
           params:  { order: { restaurant: 'Restaurant under Create Order' } },
           headers: headers

      newest_order = orders(user: current_user_email).first
      expect(newest_order).to eql({ 'user' => { 'email' => current_user_email }, 'restaurant' => 'Restaurant under Create Order' })
    end
  end

  describe 'index' do
    context 'Orders with Group' do
      let(:group_1_order_data) { { 'user' => { 'email' => order_creator_1_email }, 'restaurant' => restaurant_1 } }
      let(:group_2_order_data) { { 'user' => { 'email' => order_creator_2_email }, 'restaurant' => restaurant_2 } }
      let(:member_of_group_1_email) { 'eater-1@order-list.com' }
      let(:member_of_group_1_and_2_email) { 'eater-2@order-list.com' }
      let(:member_of_group_2_email) { 'eater-3@order-list.com' }
      let(:order_creator_1_email) { 'order-creator-1@order-list.com' }
      let(:order_creator_2_email) { 'order-creator-2@order-list.com' }
      let(:restaurant_1) { 'Restaurant under Group #1' }
      let(:restaurant_2) { 'Restaurant under Group #2' }

      before do
        create_user(order_creator_1_email)
        create_user(order_creator_2_email)
        create_user(member_of_group_1_email)
        create_user(member_of_group_1_and_2_email)
        create_user(member_of_group_2_email)

        create_group(
          creator: order_creator_1_email,                                               # As 1st User
          members_emails: [member_of_group_1_email, member_of_group_1_and_2_email])     # create Group
        newest_group_id = groups_ids(current_user_email: order_creator_1_email).first
        create_order(                                                                   # and Create Order for newly created Group
          group_id:           newest_group_id,
          restaurant:         restaurant_1,
          current_user_email: order_creator_1_email)

        create_group(
          creator: order_creator_2_email,                                               # As 2nd User
          members_emails: [member_of_group_2_email, member_of_group_1_and_2_email])     # create Group
        newest_group_id = groups_ids(current_user_email: order_creator_2_email).first
        create_order(                                                                   # and Create Order for newly created Group
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
  end
end
