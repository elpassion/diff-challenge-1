require 'spec_helper'

describe 'Groups management', type: :request do
  describe 'create' do
    before do
      create_user 'group-creator@group-create.com'
      create_user 'group-memeber-1@group-create.com'
      create_user 'group-memeber-2@group-create.com'
    end

    it 'should create Group' do
      # Create Group
      access_token = get_user_access_token(email: 'group-creator@group-create.com')
      post GROUPS_PATH,
           params: { group: { emails: ['group-memeber-1@group-create.com', 'group-memeber-2@group-create.com'] } },
           headers: build_access_token_header(access_token: access_token)

      # List groups to check if Group was successfully created
      get GROUPS_PATH, headers: build_access_token_header(access_token: access_token)

      newest_group              = json_response.fetch('results').first
      newest_group_users_emails = newest_group.fetch('users').map { |user| user.fetch('email') }

      # Users should be sorted by email
      expected                  = [
        'group-creator@group-create.com', # Group creator always belongs to the group
        'group-memeber-1@group-create.com',
        'group-memeber-2@group-create.com'
      ]
      expect(newest_group_users_emails).to eql(expected)
    end
  end

  # This is actually only to make sure that groups ids can be fetched. They are required to perform other tests.
  describe 'index' do
    before do
      create_user 'group-creator@group-index.com'
      create_user 'group-memeber-1@group-index.com'
      access_token = get_user_access_token(email: 'group-creator@group-index.com')
      create_group(emails: ['group-memeber-1@group-index.com'], access_token: access_token)
    end

    it 'should list Group sorted by created at' do
      access_token = get_user_access_token(email: 'group-creator@group-index.com')
      get GROUPS_PATH, headers: build_access_token_header(access_token: access_token)

      newest_group = json_response.fetch('results').first
      group_id     = newest_group['id']

      expect(group_id).to be_instance_of(Fixnum)
    end
  end
end
