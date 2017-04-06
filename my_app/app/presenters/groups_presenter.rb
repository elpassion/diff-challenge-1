class GroupsPresenter < SimpleDelegator
  def as_json(_ = nil)
    { results: groups.order(created_at: :desc).map { |group| GroupPresenter.new(group).as_json } }
  end
end
