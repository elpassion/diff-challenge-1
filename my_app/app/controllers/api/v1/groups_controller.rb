class Api::V1::GroupsController < ApplicationController
  before_action :authorize

  def index
    render json: GroupsPresenter.new(current_user).as_json
  end

  def create
    users = User.where(email: create_params).all
    group = current_user.groups.where(memberships: { user_id: users } ).first_or_create
    group.users << users
    render json: GroupPresenter.new(group).as_json
  end

  private

  def create_params
    params.require(:group).require(:emails)
  end
end
