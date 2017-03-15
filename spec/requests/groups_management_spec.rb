require 'spec_helper'

describe 'Groups management', type: :request do
  describe 'POST /groups' do
    before do
      create_user(group_creator)
      create_user(first_group_member)
      create_user(second_group_member)
    end

    let(:group_creator) { 'group-creator@group-create.com' }
    let(:first_group_member) { 'group-member-1@group-create.com' }
    let(:second_group_member) { 'group-member-2@group-create.com' }
    let(:headers) { access_token_header(email: group_creator) }

    it 'should create Group' do
      # Create Group
      post GROUPS_PATH,
           params:  { group: { emails: [first_group_member, second_group_member] } },
           headers: headers

      # List groups to check if Group was successfully created
      get GROUPS_PATH, headers: headers

      newest_group              = json_response.fetch('results').first
      newest_group_users_emails = newest_group.fetch('users').map { |user| user.fetch('email') }

      # Users should be sorted by email
      expected                  = [
        group_creator, # Group creator always belongs to the group
        first_group_member,
        second_group_member
      ]
      expect(newest_group_users_emails).to eql(expected)
    end
  end

  # This is actually only to make sure that groups ids can be fetched. They are required to perform other tests.
  describe 'GET /groups' do
    before do
      create_user(group_creator)
      create_user(group_member)
      create_group(creator: group_creator, members_emails: [group_member])
    end

    let(:group_creator) { 'group-creator@group-index.com' }
    let(:group_member) { 'group-member-1@group-index.com' }
    let(:headers) { access_token_header(email: group_creator) }

    it 'should list Group sorted by created at' do
      get GROUPS_PATH, headers: headers

      newest_group = json_response.fetch('results').first
      group_id     = newest_group['id']

      expect(group_id).to be_instance_of(Fixnum)
    end
  end
end
