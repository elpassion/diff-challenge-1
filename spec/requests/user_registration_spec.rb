require 'spec_helper'

describe 'User registration', type: :request do
  let(:email) { 'foo@bar.com' }
  let(:password) { 'Very long password' }

  it 'should create User who can sign in' do
    # Create user
    post SIGN_UP_PATH, params: { user: { email: email, password: password, password_confirmation: password } }

    # Sign in with created User to get access token
    post SIGN_IN_PATH, params: { email: email, password: password }
    access_token = json_response.fetch('access_token')

    # Test authentication
    get ORDERS_PATH, headers: { "X-Access-Token" => access_token }
    expect(response).to be_ok

    get ORDERS_PATH, headers: { "X-Access-Token" => 'wrong access token' }
    expect(response).to be_unauthorized
  end
end
