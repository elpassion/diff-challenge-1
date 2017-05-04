class CreateOrder
  def call
    order = founder.orders.create!(founder: founder, restaurant: params[:restaurant])
    order.purchasers << purchasers
    order
  end

  private

  attr_reader :founder, :params

  def initialize(founder:, params:)
    @founder = founder
    @params = params
  end

  def purchasers
    group&.users || invited_users
  end

  def invited_users
    User.where(email: params[:invited_users_emails]).all
  end

  def group
    Group.where(id: params[:group_id].to_i).first
  end
end
