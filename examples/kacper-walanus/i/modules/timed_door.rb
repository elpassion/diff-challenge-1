require_relative 'door'
require_relative 'timer_client'

class TimedDoor
  include Door
  include TimerClient

  def open
    super
    register(expires_in, object_id)
  end

  def timeout
    super
    close if open?
  end

  private

  def expires_in
    5
  end
end
