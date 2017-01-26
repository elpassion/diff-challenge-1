require_relative 'timer_client'

class DoorTimerAdapter < TimerClient
  def initialize(timed_door, expires_in)
    @timed_door = timed_door
    register(expires_in, @timed_door.object_id)
  end

  def timeout
    super
    @timed_door.close_with_timeout
  end
end