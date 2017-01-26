# TimerClient instance can subscribe to Timer using #register method.
# When timeout expires, subscribed TimerClient instance receives #timeout message.

require_relative 'timer'

class TimerClient

  def register(expires_in, timeout_id = nil)
    timeout_id ||= object_id
    Timer.new(self, expires_in, timeout_id).register
  end

  def timeout
    puts "[#{object_id}] RECEIVING TIMEOUT"
  end

end

