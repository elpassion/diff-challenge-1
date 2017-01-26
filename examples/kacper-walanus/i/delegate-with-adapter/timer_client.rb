require_relative '../excercise/timer'

class TimerClient
  def register(expires_in, timeout_id = nil)
    timeout_id ||= object_id
    Timer.new(self, expires_in, timeout_id).register
  end

  # called by Timer when the time comes
  def timeout
    puts 'RECEIVING TIMEOUT'
  end
end