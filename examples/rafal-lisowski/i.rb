################################################################################
################################################################################
####                                                                        ####
####                  Interface segregation principle                       ####
####                                                                        ####
################################################################################
################################################################################

# bad

class User
  def name
    'King Leon the First'
  end

  def notify
    # send mail
  end
end

class Messenger
  def notify
    king.notify
  end
end

class Presenter
  def yield
    king.name
  end
end

# better

class User
  def name
    'King Leon the First'
  end
end

class Notifier
  def notify
    # send mail
  end
end

class Messenger
  def notify
    notifier.notify
  end
end

class Presenter
  def yield
    king.name
  end
end



module AaInterface
  def a
    raise NotImplemented # ScriptError Exception
  end
end

class B
  include AaInterface

end
