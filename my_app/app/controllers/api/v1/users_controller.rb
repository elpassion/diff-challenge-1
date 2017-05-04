class Api::V1::UsersController < ApplicationController
  def sign_up
    user = User.new(user_params)
    unless user.save
      render status: :unprocessable_entity
      return
    end
    render json: AuthTokenPresenter.new(user).as_json
  end

  def sign_in
    user = User.find_by_email(params[:email])
    unless user && user.authenticate(params[:password])
      render status: :unprocessable_entity
      return
    end
    render json: AuthTokenPresenter.new(user).as_json
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
