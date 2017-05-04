class UserPresenter < SimpleDelegator
  def as_json(_ = nil)
    { email: email }
  end
end
