Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'users/sign_up'
      post 'users/sign_in'

      get 'orders' => 'orders#index'
    end
  end
end
