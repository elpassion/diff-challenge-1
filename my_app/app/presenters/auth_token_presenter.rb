class AuthTokenPresenter < SimpleDelegator
  def as_json(_ = nil)
    { access_token: access_token }
  end
end
