
###
add event handler

@param handler {Function} function to execute whenever an event is received
  @param data {Object} event data
  @param ev {Object} raw event
  @this {Object} the firing element
###

Stalker.addHandler = (handler) ->
  Stalker._handlers.push(handler)