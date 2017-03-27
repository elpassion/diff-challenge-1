class Api::V1::OrdersController < ApplicationController
  before_action :authorize

  def index
    render json: {}
  end
end
