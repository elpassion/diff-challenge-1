class Timer
  def initialize(timer_client, timeout, timeout_id)
    @timer_client = timer_client
    @timeout = timeout
    @timeout_id = timeout_id
  end

  def register
    thread.exit if thread

    self.class.threads[@timeout_id] = Thread.new do
      loop do
        print "[#{@timeout_id.object_id}] Expires in: #{@timeout}\n"
        @timeout -= 1
        if @timeout < 1
          notify_client
          break
        end
        sleep 1
      end
    end
  end

  def self.threads
    @threads ||= {}
  end

  private

  def thread
    self.class.threads[@timeout_id]
  end

  def notify_client
    @timer_client.timeout
  end
end
