require_relative '../drop_down'

class DropDown::Users < DropDown
  def initialize(user:, locale:, teams_drop_down_value:)
    @user = user
    @locale = locale
    @teams_drop_down_value = teams_drop_down_value
  end

  def locale
    @locale
  end

  def title_key
    'employees'
  end

  def options
    case @teams_drop_down_value
      when :managers then managers_options
      else
        []
    end
  end

  private

  def managers_options
    options_wrapper do
      managers.map do |manager|
        OpenStruct.new( name: manager[:name], value: manager[:id] )
      end
    end
  end

  def managers
    # @user.managers
    [
      { name: 'President', id: 1 },
      { name: 'Vice President', id: 2 },
    ]
  end
end
