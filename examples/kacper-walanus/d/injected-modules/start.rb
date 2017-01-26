require_relative 'drop_down'
require_relative 'drop_down/users'
# require_relative 'drop_down/teams'

class User
  def manager?
    true
  end
end
teams_drop_down_value = :managers
user = User.new

dd = DropDown::Data::Users.new(
  locale: :en,
  teams_drop_down_value: teams_drop_down_value,
  user: user,
  ui: DropDown::Ui::Basic
)
puts dd.title
puts dd.options

