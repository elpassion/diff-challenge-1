################################################################################
################################################################################
####                                                                        ####
####                  Open/closed principle                                 ####
####                                                                        ####
################################################################################
################################################################################

################################################################################
#                         Inheritance                                          #
################################################################################

class Logger
  def debug(message)
    puts message
  end
end

class FileLogger < Logger
  def initialize
    $stderr.reopen(logfile_path, 'a')
    $stdout.reopen($stderr)
  end
end

logger = Logger.new
logger.debug

logger = FileLogger.new
logger.debug


################################################################################
#                         Strategy                                             #
################################################################################

class Logger
  attr_reader :handler

  def initialize(handler: $stdout)
    @handler = handler
  end

  def debug(message)
    handler.puts message
  end
end

class FileHnadler
  def debug(message)
    file.puts message
  end

  # ... file handling code
end


logger = Logger.new
logger.debug

file_handler = FileHnadler.new
logger = Logger.new(file_handler)
logger.debug

################################################################################
#                         Delagator                                            #
################################################################################

class User
  def first_name
    'John'
  end

  def last_name
    'Snow'
  end
end

class UserPresenter < SimpleDelegator
  def full_name
    [first_name, last_name].compact.join(' ')
  end
end

class AdminPresenter < SimpleDelegator
  def full_name
    [role, first_name, last_name].compact.join(' ')
  end

  def role
    'super admin'
  end
end

user = User.new
puts user.first_name
puts user.last_name

user = UserPresenter.new(user)
puts user.first_name
puts user.last_name
puts user.full_name

user = AdminPresenter.new(user)
puts user.first_name
puts user.last_name
puts user.full_name
