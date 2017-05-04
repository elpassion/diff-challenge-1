class Api::V1::OrdersController < ApplicationController
  before_action :authorize

  def index
    render json: OrdersPresenter.new(current_user).as_json
  end

  def create
    order = CreateOrder.new(founder: current_user, params: create_params).call
    render json: OrderPresenter.new(order).as_json
  end

  private

  def create_params
    params.require(:order).permit(:restaurant, :group_id, invited_users_emails: [])
  end
end
