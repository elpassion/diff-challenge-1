class UserPresenter < SimpleDelegator
  def as_json(_ = nil)
    { access_token: 'dummy_access_token' }
  end
end
