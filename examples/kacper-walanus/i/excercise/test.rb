# require_relative '../delegate-with-adapter/timed_door'
# require_relative '../inheritence-with-adapter/timed_door'
require_relative '../modules/timed_door'
# require_relative 'timed_door'
require_relative 'timer'

timed_door = TimedDoor.new
timed_door.open
timed_door.close
sleep 1.2
timed_door.open

loop do
  break if Timer.threads.values.all? { |thread| thread.status == false }
  sleep 1
end

# Example output:
# OPENING DOOR
# CLOSING DOOR
# [140480789035921] Expires in: 5
# [140480789035921] Expires in: 4
# OPENING DOOR
# [140480789035921] Expires in: 5
# [140480789035921] Expires in: 4
# [140480789035921] Expires in: 3
# [140480789035921] Expires in: 2
# [140480789035921] Expires in: 1
# RECEIVING TIMEOUT
# DOOR CLOSED AUTOMATICALLY
# CLOSING DOOR