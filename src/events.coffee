
###
retrieve relevant data then invoke all user-added handlers

@param event {Object} raw event
###

Stalker._uiHandler = (ev) ->
  return if ev.target.tagName.toLowerCase() not in Stalker._tags

  target = ev.target

  data = {
    action: target.getAttribute('data-behavior') || target.innerText
  }

  seekNode = target
  while (!(data.context = seekNode.getAttribute('data-context')) && seekNode.tagName != 'BODY')
    seekNode = seekNode.parentNode
  data.context ||= ''

  handler.call(target, data, ev) for handler in Stalker._handlers

###
invoke all handlers based on custom data

@param data {Object} event data user passed-in
###

Stalker._customHandler = (data) ->
  handler(data, null) for handler in Stalker._handlers

###
manually submit a custom event

@param data {Object} JSON event data
###

Stalker.submit = (data) ->
  Stalker._customHandler(data)