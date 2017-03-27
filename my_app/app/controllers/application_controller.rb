class ApplicationController < ActionController::API
  private

  def current_user
    @current_user ||= User.find_by_access_token(request.headers['X-Access-Token'])
  end

  def authorize
    render status: :unauthorized unless current_user
  end
end
