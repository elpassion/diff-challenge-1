class GroupPresenter < SimpleDelegator
  def as_json(_ = nil)
    { id: id,
      users: users.map { |user| UserPresenter.new(user).as_json } }
  end
end
