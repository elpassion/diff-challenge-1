class OrderPresenter < SimpleDelegator
  def as_json(_ = nil)
    { founder: UserPresenter.new(founder).as_json,
      restaurant: restaurant,
      invited_users: purchasers.order(:email).map {|user| UserPresenter.new(user).as_json } }
  end
end
