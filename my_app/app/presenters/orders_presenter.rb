class OrdersPresenter < SimpleDelegator
  def as_json(_ = nil)
    { results: orders.order(created_at: :desc).distinct.map { |order| OrderPresenter.new(order).as_json } }
  end
end
