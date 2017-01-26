require_relative '../drop_down'

class DropDown::Teams < DropDown
  def initialize(user:, locale:)
    @user = user
    @locale = locale
  end

  def locale
    @locale
  end

  def title_key
    'teams'
  end

  def option_keys
    [].tap do |teams|
      teams << 'managers' if @user.manager?
      teams << 'sales'
      teams << 'developers'
    end
  end
end
