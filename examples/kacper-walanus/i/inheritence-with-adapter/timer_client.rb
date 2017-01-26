require_relative '../excercise/timer'

class TimerClient

  def register(expires_in, timeout_id = nil)
    timeout_id ||= object_id
    Timer.new(self, expires_in, timeout_id).register
  end

  def timeout
    puts "[#{object_id}] RECEIVING TIMEOUT"
  end

end
