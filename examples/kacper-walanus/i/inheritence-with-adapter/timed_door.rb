require_relative 'door'
require_relative 'door_timer_adapter'

class TimedDoor < Door

  def close_with_timeout
    puts "DOOR CLOSED AUTOMATICALLY"
    close if open?
  end

  def open
    super
    DoorTimerAdapter.new(self, expires_in)
  end

  private

  def expires_in
    5
  end
end
