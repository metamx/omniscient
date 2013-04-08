
###
add event handler

@param handler {Function} function to execute whenever an event is received
  @param data {Object} event data
  @param ev {Object} raw event
  @this {Object} the firing element
###

Omniscient.addHandler = (handler) ->
  Omniscient._handlers.push(handler)
  return