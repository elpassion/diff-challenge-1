require 'spec_helper'

describe 'Groups management', type: :request do
  describe 'create' do
    before do
      create_user(current_user_email)
      create_user(group_member_1_email)
      create_user(group_member_2_email)
    end

    let(:current_user_email) { 'group-creator@group-create.com' }
    let(:group_member_1_email) { 'group-member-1@group-create.com' }
    let(:group_member_2_email) { 'group-member-2@group-create.com' }
    let(:headers) { access_token_header(email: current_user_email) }

    it 'should create Group' do
      # Create Group
      post GROUPS_PATH,
           params:  { group: { emails: [group_member_1_email, group_member_2_email] } },
           headers: headers

      # List groups to check if Group was successfully created
      get GROUPS_PATH, headers: headers

      newest_group              = json_response.fetch('results').first
      newest_group_users_emails = newest_group.fetch('users').map { |user| user.fetch('email') }

      # Users should be sorted by email
      expected                  = [
        current_user_email, # Group creator always belongs to the group
        group_member_1_email,
        group_member_2_email
      ]
      expect(newest_group_users_emails).to eql(expected)
    end
  end

  # This is actually only to make sure that groups ids can be fetched. They are required to perform other tests.
  describe 'index' do
    before do
      create_user(current_user_email)
      create_user(group_member_email)
      create_group(creator: current_user_email, members_emails: [group_member_email])
    end

    let(:current_user_email) { 'group-creator@group-index.com' }
    let(:group_member_email) { 'group-member-1@group-index.com' }
    let(:headers) { access_token_header(email: current_user_email) }

    it 'should list Group sorted by created at' do
      get GROUPS_PATH, headers: headers

      newest_group = json_response.fetch('results').first
      group_id     = newest_group['id']

      expect(group_id).to be_instance_of(Fixnum)
    end
  end
end
