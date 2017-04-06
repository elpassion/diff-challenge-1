class GroupPresenter < SimpleDelegator
  def as_json(_ = nil)
    { id: id,
      users: users.order(:email).map { |user| UserPresenter.new(user).as_json } }
  end
end
