Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'users/sign_up'
    end
  end
end
