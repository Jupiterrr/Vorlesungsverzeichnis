window.delay = (ms, func) -> setTimeout func, ms
window.console ||= log: -> false
window.callstack = () ->
  try 
    capture.error
  catch e
    return e.stack
