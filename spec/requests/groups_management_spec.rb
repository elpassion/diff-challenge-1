require 'spec_helper'

describe 'Groups management', type: :request do
  describe 'create' do
    before do
      create_user 'group-memeber-1@group-create.com'
      create_user 'group-memeber-2@group-create.com'
    end

    it 'should create Group' do
      # Create Group
      post GROUPS_PATH, params: { group: { emails: ['group-memeber-1@group-create.com', 'group-memeber-2@group-create.com'] } }, headers: default_access_token_header

      # List groups to check if Group was successfully created
      get GROUPS_PATH, headers: default_access_token_header

      newest_group              = json_response.fetch('results').first
      newest_group_users_emails = newest_group.fetch('users').map { |user| user.fetch('email') }

      # Users should be sorted by email
      expected                  = [
        'foo@bar.com', # Group creator always belongs to the group
        'group-memeber-1@group-create.com',
        'group-memeber-2@group-create.com'
      ]
      expect(newest_group_users_emails).to eql(expected)
    end
  end

  # This is actually only to make sure that groups ids can be fetched. They are required to perform other tests.
  describe 'index' do
    before do
      create_user 'group-memeber-1@group-index.com'
      create_group(emails: ['group-memeber-1@group-index.com'])
    end

    it 'should list Group sorted by created at' do
      get GROUPS_PATH, headers: default_access_token_header

      newest_group = json_response.fetch('results').first
      group_id     = newest_group['id']

      expect(group_id).to be_instance_of(Fixnum)
    end
  end
end
