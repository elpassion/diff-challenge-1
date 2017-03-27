class Api::V1::UsersController < ApplicationController
  def sign_up
    user = User.new(user_params)
    unless user.save
      render status: :unprocessable_entity
      return
    end
    render json: UserPresenter.new(user).as_json
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
