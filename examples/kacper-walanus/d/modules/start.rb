require_relative 'drop_down/users'
# require_relative 'drop_down/teams'

class User
  def manager?
    true
  end
end
teams_drop_down_value = :managers
user = User.new

dd = DropDown::Users.new(locale: :en, teams_drop_down_value: teams_drop_down_value, user: user)
puts dd.title
puts dd.options

# dd = DropDown::Teams.new(locale: :en, user: user)
# puts dd.title
# puts dd.options

module Foo
  def bar
    foo
    puts 'bar'
  end
end

class Bar
  def foo
    puts 'foo!'
  end

  def bar
    extended.bar
  end

  def extended
    self.extend(Foo)
  end
end

bar = Bar.new
# bar.extend(Foo).bar
bar.bar