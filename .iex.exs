ss = fn() ->
  require Logger
  Logger.warn("Loop starting....")
  Flocking.WorldStateUpdater.start_link()
end

rs = fn() ->
  require Logger
  Logger.warn("Loop stopping....")
  Flocking.WorldStateUpdater.stop_loop()
  Logger.warn("Module reloading....")
  r  Flocking.WorldStateUpdater
  Logger.warn("Loop starting....")
  Flocking.WorldStateUpdater.start_link()
end
