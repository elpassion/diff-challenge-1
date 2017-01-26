5 seconds after opening, i.e. receiving `#open` method, `TimedDoor` instance should be closed automatically, 
i.e. it should receive `#close_with_timeout` message.
See `TimerClient` class description and `test.rb` script for more details.
