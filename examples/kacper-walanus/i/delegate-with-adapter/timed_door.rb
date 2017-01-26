require_relative 'door'
require_relative 'door_timer_adapter'

class TimedDoor
  def close
    door.close
  end

  def open
    door.open
    DoorTimerAdapter.new(self, expires_in)
  end

  def open?
    door.open?
  end

  def close_with_timeout
    puts "DOOR CLOSED AUTOMATICALLY"
    close if open?
  end

  private

  def door
    @door ||= Door.new
  end

  def expires_in
    5
  end
end
