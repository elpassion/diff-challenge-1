class GroupsPresenter < SimpleDelegator
  def as_json(_ = nil)
    { results: groups.map { |group| GroupPresenter.new(group).as_json } }
  end
end
