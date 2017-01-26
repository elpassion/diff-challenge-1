require_relative 'door'

class TimedDoor < Door

  def close_with_timeout
    puts "DOOR CLOSED AUTOMATICALLY"
    close if open?
  end

  private

  def expires_in
    5
  end
end
