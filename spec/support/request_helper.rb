module Request
  module JsonHelper
    def json_response
      JSON.parse(response.body)
    end
  end

  module HTTPHelper
    require 'httparty'

    class TestedAPI
      include HTTParty
      base_uri API_HOST
    end

    class HTTPartyResponseToRSpecResponseAdapter < SimpleDelegator
      def ok?
        code == 200
      end
    end

    def get(url, options = {})
      new_options = {}
      new_options[:body] = options[:params]
      new_options[:headers] = options[:headers]
      @response = TestedAPI.get(url, new_options)
    end

    def post(url, options = {})
      new_options = {}
      new_options[:body] = options[:params]
      new_options[:headers] = options[:headers]
      response = TestedAPI.post(url, new_options)
      @response = HTTPartyResponseToRSpecResponseAdapter.new(response)
    end

    def response
      @response
    end
  end

  module OrderHelper
    def create_order(restaurant:, access_token: nil)
      post ORDERS_PATH, params: { order: { restaurant: restaurant } }, headers: build_access_token_header(access_token: access_token)
    end
  end

  module SignInHelper
    def default_access_token_header
      create_user
      access_token = get_user_access_token
      { "X-Access-Token" => access_token }
    end

    def build_access_token_header(access_token: nil)
      if access_token
        { "X-Access-Token" => access_token }
      else
        default_access_token_header
      end
    end

    def get_user_access_token(email = 'foo@bar.com', password = 'Very long password')
      post SIGN_IN_PATH, params: { email: email, password: password }
      json_response.fetch('access_token')
    end

    def create_user(email = 'foo@bar.com', password = 'Very long password')
      post SIGN_UP_PATH, params: { user: { email: email, password: password, password_confirmation: password } }
    end
  end
end

RSpec.configure do |config|
  config.include Request::HTTPHelper, type: :request
  config.include Request::JsonHelper, type: :request
  config.include Request::OrderHelper, type: :request
  config.include Request::SignInHelper, type: :request
end
